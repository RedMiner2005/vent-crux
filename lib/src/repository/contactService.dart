import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libPhone;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/repository.dart';

enum ContactStatus {
  registered,
  unregistered
}

class ContactService {
  ContactService({required DataService dataService}) {
    _dataService = dataService;
    // FlutterContacts.requestPermission(readonly: true);
    libPhone.init().then(
        (_) {
          FlutterContacts.addListener(() => unawaited(sync()));
          unawaited(sync());
        }
    );
  }

  late final DataService _dataService;
  final _firestore = FirebaseFirestore.instance;

  static Future<String?> get_e164(String number) async {
    try {
      return (await libPhone.parse(number))["e164"];
    } catch (e) {
      final res = await libPhone.getFormattedParseResult(number, libPhone.CountryManager().countries.firstWhere((element) => element.phoneCode == VentConfig.defaultCountryCode.toString()));
      return res?.e164;
    }
  }

  static Future<bool> isValidPhone(String number) async {
    try {
      await libPhone.parse(number);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String getPhoneHash(String phone) {
    List<int> bytes = utf8.encode(phone);
    return sha256.convert(bytes).toString();
  }

  Future<ContactStatus> checkIfRegistered(String phone) async {
    return ((await _firestore.collection(VentConfig.usersCollection)
      .doc(getPhoneHash(phone))
      .get())
      .exists) ? ContactStatus.registered : ContactStatus.unregistered;
  }

  Future<bool> sync() async {
    List<String> phones = [];
    List<String> names = [];
    if (await FlutterContacts.requestPermission(readonly: true)) {
      final contacts = Map.fromEntries((await (await FlutterContacts.getContacts(withProperties: true))
          .map((contact) => contact.phones.map((phone) async {
            final number = (phone.number.startsWith("+")) ? phone.normalizedNumber : "+${VentConfig.defaultCountryCode}${phone.number.replaceAll('[- ()]', '')}";
            final status = await checkIfRegistered(number);
            if (status == ContactStatus.registered) {
              return MapEntry(number, contact.displayName);
            } else {
              return null;
            }
          }).wait).wait)
          .expand((element) => element)
          .where((element) => element != null)
          .map((e) => e!)
          .toList());
      // await Future.wait(contacts, (Contact contact) {
      //   contact.phones.forEach((phone) async {
      //     final status = await checkIfRegistered(phone.normalizedNumber);
      //     if (status == ContactStatus.registered) {
      //       print(phone.normalizedNumber);
      //       phones.add(phone.normalizedNumber);
      //       names.add(contact.displayName);
      //       print(phones);
      //     }
      //   });
      // });
      // final contacts = Map.fromIterables(phones, names);
      print(contacts);
      _dataService.saveContactsToCache(contacts);
    } else {
      print("Contact permission denied.");
      return false;
    }
    print("Contact cache sync completed.");
    return true;
  }

  Future<List<Map<String, dynamic>>> findMatches(String? name) async {
    Map<String, dynamic> contactCache = await _dataService.getContactCache();
    print(contactCache);
    if (contactCache.isEmpty) {
      return [];
    }
    if (name == null) {
      print("Null Match");
      return contactCache
          .map((key, value) => MapEntry(key, {"confidence": 100, "name": value, "hash": ContactService.getPhoneHash(key), "phone": key}))
          .values.toList();
    }
    print("Regular Match");
    List<Map<String, dynamic>> matches =
        contactCache
          .map((key, value) => MapEntry(key, {"confidence": tokenSetPartialRatio(name, value), "name": value, "hash": ContactService.getPhoneHash(key), "phone": key}))
          .values.toList();
    matches.sort((a, b) => b["confidence"].compareTo(a["confidence"]));
    matches.removeWhere((element) => element["confidence"] < 85);
    if (matches.isEmpty) {
      return await findMatches(null);
    }
    return matches;
  }
}