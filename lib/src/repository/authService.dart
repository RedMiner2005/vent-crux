import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/src/src.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


String _getUserId(String phone) {
  List<int> bytes = utf8.encode(phone);
  return sha256.convert(bytes).toString();
}

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
    String hash = _getUserId(user.phone);
    user = user.copyWith(id: hash);
    if (!(await checkUserExists(user.id ?? hash))) {
      await _firestore
          .collection(VentConfig.usersCollection)
          .doc(user.id)
          .set({
        'createdAt': FieldValue.serverTimestamp(),
        'phone': user.phone,
        'notification_token': _dataService.notificationToken,
        'inbox': [],
      });
    }
    userObject = user;
  }

  Future<void> setNotificationToken(String userId) async {
    try {
      await _firestore
          .collection(VentConfig.usersCollection)
          .doc(userId)
          .update({
        "notification_token": _dataService.notificationToken
      });
    } catch (e) {
      await _firestore
          .collection(VentConfig.usersCollection)
          .doc(userId)
          .set({
        "notification_token": _dataService.notificationToken
      });
    }
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

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      UserModel user = firebaseUser == null ? UserModel.empty : firebaseUser.toUserModel;
      if (firebaseUser != null) {
        setNotificationToken(_getUserId(user.phone));
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
      userObject = user;
      return user;
    }
  }
  
  Stream<int> get unreadCount {
    return _firestore.collection(VentConfig.usersCollection)
        .doc(userObject.id)
        .snapshots()
        .asyncMap((event) => (event.data()?["unreadCount"] ?? 0) as int);
  }

  Stream<List<Map<String, dynamic>>> get inbox {
    return _firestore.collection(VentConfig.usersCollection)
        .doc(userObject.id)
        .snapshots()
        .asyncMap((event) {
          List<Map<String, dynamic>> inbox = event.data()?["inbox"] ?? [];
          return inbox.map(
                  (e) => {"message": e["message"], "time": DateTime.fromMillisecondsSinceEpoch(int.parse(utf8.fuse(base64).decode(e["time"])) * 1000)}
          ) as List<Map<String, dynamic>>;
        });
  }

  Future<void> clearUnread() async {
    await _firestore
        .collection(VentConfig.usersCollection)
        .doc(userObject.id)
        .update({
      "unreadCount": 0
    });
  }

  Future<Future<void>Function(String code, String verificationId, Function(dynamic exception) codeVerificationFailed)> logInWithPhone(
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
          createUser(UserModel(phone: phone)).then((_) {
            if (_firebaseAuth.currentUser != null) {
              setNotificationToken(_getUserId(phone));
            }
            verificationCompleted();
          });
        },
        verificationFailed: (firebase_auth.FirebaseAuthException exception) {
          verificationFailed(exception);
        },
        codeSent: (verificationId, forceResendingToken) {
          codeSent(phone, verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
    return (String code, String verificationId, Function(dynamic exception) codeVerificationFailed) => _codeAttempt(phone, code, verificationId, verificationCompleted, codeVerificationFailed);
  }

  Future<void> _codeAttempt(
      String phone,
      String code,
      String verificationId,
      Function verificationCompleted,
      Function(dynamic exception) verificationFailed,
  ) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      await _firebaseAuth.signInWithCredential(credential);
      createUser(UserModel(phone: phone));
      if (_firebaseAuth.currentUser != null) {
        setNotificationToken(_getUserId(phone));
      }
      verificationCompleted();
    } catch (e) {
      verificationFailed(e);
    }
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
    return UserModel(id: _getUserId(phoneNumber ?? ""), phone: phoneNumber ?? "");
  }
}