import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VentConfig {
  static const usersCollection = "users";
  static const userCacheKey = "__user_cache_key__";
  static const runOnceCacheKey = "__run_once_cache_key__";
  static const registeredContactCacheKey = "__registered_contact_cache_key__";
  static const unregisteredContactCacheKey = "__unregistered_contact_cache_key__";
  static const backendURL = "https://vent-crux-backend.onrender.com";
  static const brandingColor = const Color(0x1A6BFF);

  static const defaultCountryCode = 91;

  static final DateFormat dateFormat = DateFormat("dd MMM yyyy");
  static final DateFormat weekdayFormat = DateFormat("EEEE");
  static final DateFormat timeFormat = DateFormat.jm();

  // Animations
  static const Duration ANIMATION_DURATION = Duration(milliseconds: 375);
  static const Duration ANIMATION_PAGE_SWIPE_DURATION = Duration(milliseconds: 250);
  static const double ANIMATION_SLIDE_OFFSET = 20.0;

  // static const voskModelPath = 'assets/speech/vosk-model-small-en-us-0.15.zip';
  // static const voskSampleRate = 16000;
}

Map<Brightness, ThemeData> themeBuilder() {
  return {
    Brightness.light: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: VentConfig.brandingColor,
        ),
        useMaterial3: true
    ),
    Brightness.dark: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: VentConfig.brandingColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true
    )
  };
}