
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:apoio_imobiliario/services/auth_service.dart';
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

  bool _carregando = false;

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Autentica o usuário pelo Firebase.
  Future<void> _entrar() async {
    if (_loginController.text.trim().isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o e-mail e a senha.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // O Firebase verifica se o e-mail e a senha estão corretos.
      await AuthService().login(
        email: _loginController.text,
        senha: _senhaController.text,
      );

      if (!mounted) return;

      // Só entra no sistema se a autenticação for bem-sucedida.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ClienteListView(),
        ),
      );
    } on FirebaseAuthException catch (erro) {
      if (!mounted) return;

      String mensagem;

      switch (erro.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          mensagem = 'E-mail ou senha incorretos.';
          break;

        case 'invalid-email':
          mensagem = 'Informe um endereço de e-mail válido.';
          break;

        case 'user-disabled':
          mensagem = 'Esta conta foi desativada.';
          break;

        case 'too-many-requests':
          mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
          break;

        case 'network-request-failed':
          mensagem = 'Verifique sua conexão com a internet.';
          break;

        default:
          mensagem = 'Não foi possível entrar. Tente novamente.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado ao entrar.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
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

              // E-mail.
              TextField(
                controller: _loginController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Login / E-mail',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Senha.
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Botão de login.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _entrar,
                  child: _carregando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Entrar'),
                ),
              ),

              const SizedBox(height: 12),

              // Primeiro acesso.
              TextButton(
                onPressed: _carregando ? null : _abrirPrimeiroAcesso,
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
