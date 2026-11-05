
import 'package:flutter/material.dart';

class AppTheme {
  // Paleta: fundo cinza quase preto, textos em cinza e verde suave só nos destaques.
  static const ColorScheme cores = ColorScheme(
    brightness: Brightness.dark,

    primary: Color.fromARGB(255, 17, 204, 108), //botões, borda em foco, links e destaque
    onPrimary: Color(0xFF0E1A14), //texto e icones em cima de primary
    primaryContainer: Color(0xFF1F2E27), //destaque discreto (chips, avatares)
    onPrimaryContainer: Color(0xFF9FC7B2), //conteúdo sobre primaryContainer
    secondary: Color(0xFF2A2E2C), //elementos de apoio
    onSecondary: Color(0xFF9AA19D), //texto e icones em cima de secondary
    error: Color(0xFFD98585), //mensagens de erro
    onError: Color(0xFF2B1111), //texto em cima da msg erro
    surface: Color(0xFF121413), //fundo das telas, cards, barras e dialogos
    onSurface: Color(0xFFC9CDCA), // conteudo exibido sobre
    onSurfaceVariant: Color(0xFF8E9591), //textos secundários e rótulos
    surfaceContainerLow: Color(0xFF0C0D0C), //fundo botão aguardando apertar
    surfaceContainer: Color(0xFF1A1C1B), //cards e campos
    surfaceContainerHigh: Color(0xFF242725), //elementos elevados
    outline: Color(0xFF3D423F), //bordas
    outlineVariant: Color(0xFF2A2D2B), //bordas sutis e divisores
  );

  static final BorderRadius _raio = BorderRadius.circular(12);

  static final ThemeData temaEscuro = ThemeData(
    useMaterial3: true,
    colorScheme: cores,
    scaffoldBackgroundColor: cores.surface,
    visualDensity: VisualDensity.standard,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: cores.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: cores.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
        disabledBackgroundColor: cores.surfaceContainerHigh,
        disabledForegroundColor: cores.onSurfaceVariant,
        elevation: 0,
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: _raio),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: cores.primary,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: cores.outline),
        shape: RoundedRectangleBorder(borderRadius: _raio),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cores.primary,
        shape: RoundedRectangleBorder(borderRadius: _raio),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cores.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: cores.onSurfaceVariant),
      floatingLabelStyle: TextStyle(color: cores.primary),
      prefixIconColor: cores.onSurfaceVariant,
      suffixIconColor: cores.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: _raio,
        borderSide: BorderSide(color: cores.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _raio,
        borderSide: BorderSide(color: cores.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _raio,
        borderSide: BorderSide(color: cores.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _raio,
        borderSide: BorderSide(color: cores.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _raio,
        borderSide: BorderSide(color: cores.error, width: 1.5),
      ),
    ),

    cardTheme: CardThemeData(
      color: cores.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cores.outlineVariant),
      ),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: cores.primary,
      textColor: cores.onSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: TextStyle(
        color: cores.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: TextStyle(color: cores.onSecondary, fontSize: 13.5),
      shape: RoundedRectangleBorder(borderRadius: _raio),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: cores.surfaceContainerHigh,
      contentTextStyle: TextStyle(color: cores.onSurface),
      shape: RoundedRectangleBorder(borderRadius: _raio),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(color: cores.primary),

    dividerTheme: DividerThemeData(
      color: cores.outlineVariant,
      thickness: 1,
      space: 1,
    ),

    iconTheme: IconThemeData(color: cores.primary),
  );

  // static final ThemeData temaEscuro = ThemeData(
  //   useMaterial3: true,
  //   colorScheme: cores,
  //   scaffoldBackgroundColor: Colors.transparent,
  // );
}
