import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF007AFF), // A vibrant, trustworthy blue
      brightness: Brightness.light,
      primary: const Color(0xFF007AFF),
      onPrimary: Colors.white,
      secondary: const Color(0xFF34C759), // A fresh green for secondary actions
      onSecondary: Colors.white,
      error: const Color(0xFFFF3B30),
      onError: Colors.white,
      background: Colors.white,
      onBackground: const Color(0xFF1D1D1F),
      surface: const Color(0xFFF2F2F7),
      onSurface: const Color(0xFF1D1D1F),
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF1D1D1F)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1D1D1F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF007AFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0A84FF), // A slightly brighter blue for dark mode
      brightness: Brightness.dark,
      primary: const Color(0xFF0A84FF),
      onPrimary: Colors.white,
      secondary: const Color(0xFF30D158), // Brighter green for dark mode
      onSecondary: Colors.black,
      error: const Color(0xFFFF453A),
      onError: Colors.black,
      background: const Color(0xFF000000),
      onBackground: const Color(0xFFE5E5EA),
      surface: const Color(0xFF1C1C1E),
      onSurface: const Color(0xFFE5E5EA),
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
       displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold),
       headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
       bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161618), // A slightly off-black for the app bar
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFFE5E5EA)),
      titleTextStyle: TextStyle(
        color: Color(0xFFE5E5EA),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0A84FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}