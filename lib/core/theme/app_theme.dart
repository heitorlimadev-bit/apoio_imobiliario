
import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme cores = ColorScheme(
    brightness: Brightness.dark,

    primary: Color.fromARGB(
      255,
      17,
      197,
      38,
    ), //botões, borda em foco, links e destaque
    onPrimary: Color.fromARGB(
      255,
      31,
      75,
      6,
    ), //texto e icones em cima de primary
    secondary: Color.fromARGB(255, 12, 85, 33), //elementos de apoio
    onSecondary: Color.fromARGB(
      255,
      65,
      209,
      8,
    ), //texto e icones em cima de secondary
    error: Color(0xFFFF6B6B), //mensagens de erro
    onError: Color(0xFF0F131D), //texto em cima da msg erro
    surface: Color.fromARGB(
      255,
      6,
      63,
      6,
    ), //fundo das telas, cards, barras e dialogos
    onSurface: Color.fromARGB(255, 255, 255, 254), // conteudo exibido sobre
    surfaceContainerLow: Color.fromARGB(
      255,
      4,
      41,
      4,
    ), //fundo botão aguardando apertar
  );

  static final ThemeData temaEscuro = ThemeData(
    useMaterial3: true,
    colorScheme: cores,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: cores.onSurface,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: cores.primary,
      textColor: cores.onSurface,
      subtitleTextStyle: TextStyle(color: cores.onSecondary),
    ),
    iconTheme: IconThemeData(color: cores.primary),
  );

  // static final ThemeData temaEscuro = ThemeData(
  //   useMaterial3: true,
  //   colorScheme: cores,
  //   scaffoldBackgroundColor: Colors.transparent,
  // );
}
