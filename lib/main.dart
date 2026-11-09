import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:apoio_imobiliario/core/theme/app_theme.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_list_view.dart';
import 'package:apoio_imobiliario/features/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Se o corretor já estiver logado, abre direto a lista de clientes.
  final logado = FirebaseAuth.instance.currentUser != null;

  runApp(
    MaterialApp(
      title: 'Apoio Imobiliário',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.temaEscuro,
      home: logado ? const ClienteListView() : const LoginView(),
    ),
  );
}
