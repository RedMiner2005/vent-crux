import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainbow_color/rainbow_color.dart';

class VentConfig {
  // Firebase and Cache
  static const usersCollection = "users";
  static const userCacheKey = "__user_cache_key__";
  static const runOnceCacheKey = "__run_once_cache_key__";
  static const registeredContactCacheKey = "__registered_contact_cache_key__";
  static const unregisteredContactCacheKey = "__unregistered_contact_cache_key__";
  static const backendURL = "https://vent-crux-backend.onrender.com";

  // Branding
  static const brandingColor = const Color(0x1A6BFF);
  static final Rainbow rainbowSpectrum = Rainbow(spectrum: const [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
    Colors.deepPurple,
  ], rangeStart: 0.0, rangeEnd: 300.0);
  static const loadingTexts = <String>[
    "Great things come to those who wait",
    "Every delay has a purpose; every wait has a meaning",
    "Waiting is the calm before the storm of success",
    "Sometimes the best things in life are worth waiting for",
    "The key to waiting is to stay focused on the goal, even when the path seems long",
    "When you feel like giving up, remember that the best things often come to those who persevere"
  ];

  // Date, time, phone, etc.
  static const defaultCountryCode = 91;
  static final DateFormat dateFormat = DateFormat("dd MMM yyyy");
  static final DateFormat weekdayFormat = DateFormat("EEEE");
  static final DateFormat timeFormat = DateFormat.jm();
  static final RegExp phoneRegex = RegExp(r'^\+[1-9]{1}[0-9]{3,14}$');
  static final RegExp codeRegex = RegExp(r'^\d{6}$');

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 375);
  static const Duration animationPageSwipeDuration = Duration(milliseconds: 250);
  static const Duration animationLoadingTextDuration = Duration(seconds: 5);
  static const Duration animationStatusText = Duration(milliseconds: 400);
  static const double animationSlideOffset = 20.0;


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