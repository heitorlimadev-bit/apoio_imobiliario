import 'package:flutter/material.dart';

// Tela de Login do Corretor
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers para pegar o que o usuário digita
    final loginController = TextEditingController();
    final senhaController = TextEditingController();

    return Scaffold(
      // Fundo branco sólido
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min, // deixa a coluna no tamanho do conteúdo


            children: [
              // Título
              const Text(
                'Desbloquear o App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // fonte preta
                ),
              ),
              const SizedBox(height: 24),



              // Campo de Login
              TextField(
                controller: loginController,
                style: const TextStyle(color: Colors.black), // texto digitado preto
                decoration: const InputDecoration(
                  labelText: 'Login',
                  labelStyle: TextStyle(color: Colors.black), // label preta

                  border: OutlineInputBorder(), // borda padrão
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // borda preta
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),



              // Campo de Senha
              TextField(
                controller: senhaController,
                obscureText: true, // esconde a senha
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.black),

                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
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