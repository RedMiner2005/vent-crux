import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/models/userModel.dart';
import 'package:vent/src/repository/contactService.dart';

class DataService {
  DataService({CacheManager? cache}):
        _cache = cache ?? DefaultCacheManager();

  final CacheManager _cache;
  String? notificationToken;

  Future<File> saveUserCache(UserModel user) {
    return _cache.putFile(VentConfig.userCacheKey, Uint8List.fromList(utf8.encode(jsonEncode(user.toJSON()))));
  }

  Future<String?> getUserCache() async {
    final res = await _cache.getFileFromCache(VentConfig.userCacheKey);
    return await res?.file.readAsString();
  }

  Future<bool> checkFirstTime(String setting) async {
    final res = await _cache.getFileFromCache(VentConfig.runOnceCacheKey);
    if (res == null || !((jsonDecode(await res.file.readAsString()) as Map<String, dynamic>).containsKey(setting))) {
      Map<String, dynamic> current = Map();
      if (res != null)
        current = jsonDecode(await res.file.readAsString());
      current[setting] = true;
      _cache.putFile(VentConfig.runOnceCacheKey, Uint8List.fromList(utf8.encode(jsonEncode(current))));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkContactCache(String phone, String name) async {
    final regFile = await _cache.getFileFromCache(VentConfig.registeredContactCacheKey);
    final hash = ContactService.getPhoneHash(phone);
    if (regFile != null) {
      final regData = jsonDecode(await regFile.file.readAsString()) as Map<String, dynamic>;
      return regData.containsKey(hash) && regData[hash] == name;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getContactCache() async {
    final regFile = await _cache.getFileFromCache(VentConfig.registeredContactCacheKey);
    if (regFile != null) {
      final regData = jsonDecode(await regFile.file.readAsString()) as Map<String, dynamic>;
      return regData;
    } else {
      return {};
    }
  }

  Future<File?> saveContactsToCache(Map<String, dynamic> contacts) async {
    final key = VentConfig.registeredContactCacheKey;

    final fileInfo = await _cache.getFileFromCache(key);
    Map<String, dynamic> prevContent = {};
    if (fileInfo != null) {
      prevContent = jsonDecode(await fileInfo.file.readAsString()) as Map<String, dynamic>;
    }

    await clearContactCache();
    return _cache.putFile(key, Uint8List.fromList(utf8.encode(jsonEncode(contacts))));
  }

  Future<void> clearContactCache() async {
    final key = VentConfig.registeredContactCacheKey;
    await _cache.removeFile(key);
  }
}