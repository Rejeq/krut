import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.withValues(alpha: 0.08),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
    labelStyle: const TextStyle(fontSize: 16.0),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xff4c662b), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff4c662b),
        brightness: Brightness.light,
        primary: const Color(0xff4c662b),
      ),
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      scaffoldBackgroundColor: const Color(0xfffefefe),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff4c662b),
        brightness: Brightness.dark,
        primary: const Color(0xffb1d18a),
      ),
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      scaffoldBackgroundColor: const Color(0xff121212),
    );
  }
}
