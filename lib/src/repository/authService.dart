import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/src/repository/contactService.dart';
import 'package:vent/src/src.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


String _getUserId(String phone) {
  return ContactService.getPhoneHash(phone);
}

class AuthenticationService {
  AuthenticationService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    DataService? dataService,
    required this.initialHomeStatus
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _dataService = dataService ?? DataService(),
        userObject = UserModel.empty;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final DataService _dataService;
  final HomeStatus initialHomeStatus;
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
        .doc(ContactService.getPhoneHash(userObject.phone))
        .snapshots()
        .asyncMap((event) => (event.data()?["unreadCount"] ?? 0) as int)
        .handleError((e) {
          print("Unread Count error: ${e.toString()}");
          return 0;
    });
  }

  Stream<List<Map<String, dynamic>>> get inbox {
    return _firestore.collection(VentConfig.usersCollection)
        .doc(ContactService.getPhoneHash(userObject.phone))
        .snapshots()
        .asyncMap((event) {
          if (event.data() != null) {
            List<Map<String, dynamic>> inboxList = (event.data()!["inbox"] as List<dynamic>).map((e) {
              late DateTime time;
              try {
                time = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(utf8.fuse(base64).decode(e["time"]))
                );
              } catch (_) {
                time = DateTime.fromMillisecondsSinceEpoch(0);
              }
              return {
                "message": e["message"],
                "time": time,
              };
            }).toList().reversed.toList();
            final int unread = event.data()!["unreadCount"] ?? 0;
            for (final (index, item) in inboxList.indexed) {
              inboxList[index]["unread"] = index < unread;
            }
            return inboxList;
          } else {
            return [];
          }
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
      Function(Exception exception) verificationFailed,
      Function(String phone, String verificationId, int? forceResendingToken) codeSent,
      Function(String verificationId) codeAutoRetrievalTimeout
  ) async {
    if (!(await checkConnection())) {
      verificationFailed(ConnectionError());
          (String code, String verificationId, Function(dynamic exception) codeVerificationFailed) => _codeAttempt(phone, code, verificationId, verificationCompleted, codeVerificationFailed);
    }
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
        removeNotificationToken(ContactService.getPhoneHash(userObject.phone)),
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