import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/models/userModel.dart';

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
}