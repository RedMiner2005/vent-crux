import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/src/src.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;



class AuthenticationService {
  AuthenticationService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    DataService? dataService
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _dataService = dataService ?? DataService(),
        userObject = UserModel.empty;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final DataService _dataService;
  UserModel userObject;

  Future<bool> checkUserExists(String userId) async {
    try {
      bool exists = (await _firestore
          .collection(VentConfig.usersCollection).doc(userId).get()).exists;
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> createUser(UserModel user) async {
    if (!(await checkUserExists(user.id))) {
      await _firestore
          .collection(VentConfig.usersCollection)
          .doc(user.id)
          .set({
        'createdAt': FieldValue.serverTimestamp(),
        'name': "",
        'phone': user.phone,
        'token': _dataService.notificationToken,
        'inbox': [],
      });
    }
  }

  Future<void> setNotificationToken(String userId) async {
    await _firestore
        .collection(VentConfig.usersCollection)
        .doc(userId)
        .update({
      "notification_token": _dataService.notificationToken
    });
  }

  Future<void> removeNotificationToken(String userId) async {
    await _firestore
        .collection(VentConfig.usersCollection)
        .doc(userId)
        .update({
      "notification_token": ""
    });
  }

  Future<UserModel> getUpdatedInbox(UserModel userModel) async {
    return userModel.copyWith(inbox: (await _firestore
        .collection(VentConfig.usersCollection)
        .doc(userModel.id)
        .get())
        .data()?["inbox"]
    );
  }

  Future<void> updateName(String name) async {
    await _firestore
        .collection(VentConfig.usersCollection)
        .doc(userObject.id)
        .update({"name": name});
    userObject = userObject.copyWith(name: name);
  }

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      UserModel user = firebaseUser == null ? UserModel.empty : firebaseUser.toUserModel;
      if (firebaseUser != null) {
        setNotificationToken(user.id);
        createUser(user);
        user = await getUpdatedInbox(user);
      }
      _dataService.saveUserCache(user);
      userObject = user;
      return user;
    });
  }

  Future<UserModel> get currentUser async {
    final data = await _dataService.getUserCache();
    if (data == null) {
      return UserModel.empty;
    } else {
      UserModel user = UserModel.fromJSON(jsonDecode(data));
      user = await getUpdatedInbox(user);
      return user;
    }
  }

  Future<void> logInWithPhone(
      String phone,
      Function verificationCompleted,
      Function(firebase_auth.FirebaseAuthException exception) verificationFailed,
      Function(String phone, String verificationId, int? forceResendingToken) codeSent,
      Function(String verificationId) codeAutoRetrievalTimeout
  ) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          if (_firebaseAuth.currentUser != null) {
            setNotificationToken(_firebaseAuth.currentUser!.uid);
          }
          verificationCompleted();
        },
        verificationFailed: (firebase_auth.FirebaseAuthException exception) {
          verificationFailed(exception);
        },
        codeSent: (verificationId, forceResendingToken) {
          codeSent(phone, verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }

  Future<void> logOut(Function(dynamic exception) logOutFailure) async {
    try {
      await Future.wait([
        removeNotificationToken(_firebaseAuth.currentUser!.uid),
        _firebaseAuth.signOut(),
        _dataService.saveUserCache(UserModel.empty),
      ]);
    } catch (e) {
      logOutFailure(e);
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [UserModel].
  UserModel get toUserModel {
    return UserModel(id: uid, phone: phoneNumber, name: displayName);
  }
}