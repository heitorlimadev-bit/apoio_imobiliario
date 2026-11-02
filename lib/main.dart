import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:apoio_imobiliario/core/theme/app_theme.dart';
import 'package:apoio_imobiliario/app.dart';
import 'package:apoio_imobiliario/features/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

void main() {
  runApp(MaterialApp(theme: AppTheme.temaEscuro, home: const App()));
} // DEPOIS SUBSTITUIR APP por LoginView, para abrir na tela de login

