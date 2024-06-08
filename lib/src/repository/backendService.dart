import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class BackendService {
  BackendService() {
    http.get(Uri.parse(VentConfig.backendURL)).then((value) => print("Connected to: " + value.body));
  }

  Future<Map<String, dynamic>> process(String input) async {
    var response = await http.post(Uri.parse('${VentConfig.backendURL}/process'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "prompt": input
        }));
    log(response.body);
    final Map result = jsonDecode(response.body);
    if (result.containsKey("error")) {
      log("Process request failed: ${result['error'] ?? 'Unknown error'}");
      Fluttertoast.showToast(msg: "We weren't able to process your vent");
      return {};
    }
    return result as Map<String, dynamic>;
  }

  Future<bool> send(String toUser, String message) async {
    var response = await http.post(Uri.parse('${VentConfig.backendURL}/send'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "toUser": toUser,
          "message": message
        }));
    final Map result = jsonDecode(response.body);
    if (result.containsKey("error")) {
      log("Send request failed: ${result['error'] ?? 'Unknown error'}");
      Fluttertoast.showToast(msg: "Unable to send, please try again later");
      return false;
    }
    return true;
  }
}