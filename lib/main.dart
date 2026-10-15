import 'package:apoio_imobiliario/freatures/App_theme.dart';
import 'package:flutter/material.dart';
import 'App.dart';
void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.temaEscuro,
      home: const App()
    )
  );
}