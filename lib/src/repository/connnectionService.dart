import 'dart:io';

class ConnectionError implements Exception {}

enum ConnectionStatus {
  connected,
  disconnected
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}

Stream<ConnectionStatus> get connectedStream async* {
  bool prevState = true;
  while(true) {
    if (prevState != await checkConnection()) {
      prevState = !prevState;
      yield (prevState) ? ConnectionStatus.connected : ConnectionStatus.disconnected;
    }
    await Future.delayed(Duration(milliseconds: (prevState) ? 2000 : 500));
  }
}