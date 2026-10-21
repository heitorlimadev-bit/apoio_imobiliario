import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme cores = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF61C36D),
    onPrimary: Color(0xFF0F131D),
    secondary: Color(0xFF1C2433),
    onSecondary: Color(0xFFFFF4D9),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF0F131D),
    surface: Color(0xFF0F131D),
    onSurface: Color(0xFFFFF4D9),
  );

  static final ThemeData temaEscuro = ThemeData(
    useMaterial3: true,
    colorScheme: cores,
  );
}
