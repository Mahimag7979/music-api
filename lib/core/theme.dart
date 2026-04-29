import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary     = Color(0xFF1DB954);
  static const Color background  = Color(0xFF121212);
  static const Color surface     = Color(0xFF1E1E1E);
  static const Color surfaceAlt  = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color accent      = Color(0xFF1DB954);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        primaryColor: primary,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          surface: surface,
          background: background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: primary,
          inactiveTrackColor: surfaceAlt,
          thumbColor: primary,
          overlayColor: Color(0x301DB954),
          trackHeight: 3,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
        textTheme: const TextTheme(
          bodyLarge:  TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
        ),
      );
}