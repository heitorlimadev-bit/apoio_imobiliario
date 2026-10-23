import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Controllers para pegar o que o usuário digita

    return Scaffold(
      // Fundo branco sólido
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // deixa a coluna no tamanho do conteúdo

            children: [
              // Título
              const Text(
                'Desbloquear o App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold, // fonte preta
                ),
              ),
              const SizedBox(height: 24),

              // Campo de Login
              TextField(
                controller: loginController,
                style: const TextStyle(), // texto digitado preto
                decoration: const InputDecoration(
                  labelText: 'Login',

                  border: OutlineInputBorder(), // borda padrão
                  enabledBorder: OutlineInputBorder(
                    // borda preta
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Senha
              TextField(
                controller: senhaController,
                obscureText: true, // esconde a senha
                style: const TextStyle(),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(),

                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botão Entrar
              ElevatedButton(
                onPressed: () {
                  // Por enquanto só mostra uma mensagem
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
    );
  }
}
