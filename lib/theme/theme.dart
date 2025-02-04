import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      hintStyle: TextStyle(
          color: Colors.white
      )
  ),
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: Colors.black54,
  ),
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle().copyWith(
      color: Colors.white,
    ),
    bodyMedium: TextStyle().copyWith(
      color: Colors.white,
    ),
  ),
);