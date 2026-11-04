import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cores.surface, cores.surfaceContainerLow],
            stops: [0.0, 0.7],
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: 1.0,
                  child: Image.asset(
                    'assets/images/SenhorCorretorLogoVerde.png',
                    height: 200, //tamanho da img, largura acompanha proporção
                  ),
                ),
                const SizedBox(height: 30), //caixa p/ logo n ficar colada
                const Text(
                  'Desbloquear o App',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Login',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  style: const TextStyle(),
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App desbloqueado!')),
                    );
                  },
                  child: const Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
