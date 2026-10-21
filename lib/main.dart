import 'package:apoio_imobiliario/freatures/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/app.dart';
void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.temaEscuro,
      home: const App()
    )
  );
}