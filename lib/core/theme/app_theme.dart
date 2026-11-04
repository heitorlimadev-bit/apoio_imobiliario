
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

    // Aparência padrão dos campos de texto.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cores.secondary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.secondary),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.secondary),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: cores.primary,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: cores.error,
          width: 2,
        ),
      ),
    ),

    // Estilos dos títulos.
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Aparência dos botões preenchidos.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
