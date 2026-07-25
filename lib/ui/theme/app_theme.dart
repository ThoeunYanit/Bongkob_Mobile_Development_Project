
import 'package:flutter/material.dart';

// defines all colors and theme
// usage in any widget:
//   AppTheme.primaryColor
//   AppTheme.successColor
// usage in main.dart:
//   theme: AppTheme.dark
class AppTheme {

  // main screen background color
  static const Color backgroundColor = Color(0xFF07080E);

  // card and container background color
  static const Color cardColor = Color(0xFF0D0E17);

  // input field background color
  static const Color inputColor = Color(0xFF13141F);

  // primary brand color — main buttons and accents
  static const Color primaryColor = Color(0xFF8B7CF8);

  // success green — success boxes and encode card
  static const Color successColor = Color(0xFF3DD68C);

  // error red — error boxes
  static const Color errorColor = Color(0xFFF87171);

  // primary text — headings and body
  static const Color textPrimary = Color(0xFFEEEEF5);

  // secondary text — subtitles and hints
  static const Color textSecondary = Color(0xFF6B6B80);

  // border and divider color
  static const Color borderColor = Color(0x14FFFFFF);

  // full ThemeData passed to MaterialApp
  // controls default styles for the whole app
  static ThemeData get dark => ThemeData(
  );
}