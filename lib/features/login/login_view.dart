
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
  // Controladores dos campos.
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  // Controla o foco entre os campos.
  final _senhaFocusNode = FocusNode();

  // Controla a visibilidade da senha.
  bool _mostrarSenha = false;

  // Controla o carregamento do botão.
  bool _carregando = false;

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    _senhaFocusNode.dispose();
    super.dispose();
  }

  // Autentica o usuário pelo Firebase.
  Future<void> _entrar() async {
    final email = _loginController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // O Firebase verifica as credenciais.
      await AuthService().login(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      // Entra na lista somente após autenticação.
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

      _mostrarMensagem(mensagem);
    } catch (erro) {
      if (!mounted) return;

      _mostrarMensagem('Ocorreu um erro inesperado ao entrar.');
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  // Exibe mensagens na tela.
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Opacity(
                    opacity: 1.0,
                    child: Image.asset(
                      'assets/images/SenhorCorretorLogoVerde.png',
                      height: 150, //tamanho da img, largura acompanha proporção
                    ),
                  ),
                  const SizedBox(height: 28), //caixa p/ logo n ficar colada
                  Text(
                    'Desbloquear o App',
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
                    decoration: const InputDecoration(
                      labelText: 'Login',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
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
      ),
    );
  }
}
