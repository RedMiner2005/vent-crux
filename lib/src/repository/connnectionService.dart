import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

// Use connectivity_plus?

class ConnectionError implements Exception {}


Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}