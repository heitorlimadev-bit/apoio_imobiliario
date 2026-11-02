
import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/login/primeiro_acesso_view.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_list_view.dart';

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

  // Encaminha o usuário para a lista de clientes.
  // Por enquanto, estamos simulando a autenticação.
  void _entrar() {
    if (_loginController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o login e a senha.'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ClienteListView(),
      ),
    );
  }

  // Abre a tela de primeiro acesso.
  void _abrirPrimeiroAcesso() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrimeiroAcessoView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home_work_outlined,
                size: 65,
              ),

              const SizedBox(height: 16),

              const Text(
                'Apoio Imobiliário',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login / E-mail',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _entrar,
                  child: const Text('Entrar'),
                ),
              ),

              const SizedBox(height: 12),

              // Opção para quem ainda não possui cadastro.
              TextButton(
                onPressed: _abrirPrimeiroAcesso,
                child: const Text(
                  'Primeiro acesso? Cadastre-se',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
