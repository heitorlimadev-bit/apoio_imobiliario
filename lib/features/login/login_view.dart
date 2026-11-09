
import 'package:apoio_imobiliario/app.dart';
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

  bool _mostrarSenha = false;
  bool _carregando = false;

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _loginController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await AuthService().login(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const App(),
        ),
        (route) => false,
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
          mensagem = 'E-mail inválido.';
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
          mensagem = 'Não foi possível entrar: ${erro.message ?? erro.code}';
      }

      _mensagem(mensagem);
    } catch (erro) {
      if (!mounted) return;
      _mensagem('Erro ao acessar a conta: $erro');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
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
            colors: [
              cores.surface,
              cores.surfaceContainerLow,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/SenhorCorretorLogoVerde.png',
                    height: 150,
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'Acesso do Corretor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: cores.onSurface,
                    ),
                  ),

                  const SizedBox(height: 28),

                  TextField(
                    controller: _loginController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    onSubmitted: (_) => _entrar(),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: _carregando
                        ? const CircularProgressIndicator()
                        : const Text('Entrar'),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _carregando
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PrimeiroAcessoView(),
                              ),
                            );
                          },
                    child: const Text('Primeiro acesso? Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
