import 'package:flutter/material.dart';

const orange = Color(0xFFFD6920);
ThemeData appTheme(bool dark) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: dark ? const Color(0xFF1F1F1F) : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: orange,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: orange,
      surface: dark ? const Color(0xFF1F1F1F) : Colors.white,
      onSurface: dark ? Colors.white : const Color(0xFF010F07),
    ),
  );
  return base.copyWith(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: base.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Colors.white : Colors.black,
      ),
    ),
    dividerColor: dark ? const Color(0xFF383838) : const Color(0xFFF0F0F0),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      hintStyle: TextStyle(
        fontSize: 14,
        color: dark ? Colors.white54 : Colors.black45,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF454545) : const Color(0xFFEFEFEF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF454545) : const Color(0xFFEFEFEF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: orange),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: dark ? Colors.white : Colors.black,
        side: BorderSide(
          color: dark ? const Color(0xFF454545) : const Color(0xFFEFEFEF),
        ),
        minimumSize: const Size(double.infinity, 52),
        textStyle: const TextStyle(fontFamily: 'Manrope', fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: orange,
        textStyle: const TextStyle(fontFamily: 'Manrope', fontSize: 13),
      ),
    ),
  );
}
