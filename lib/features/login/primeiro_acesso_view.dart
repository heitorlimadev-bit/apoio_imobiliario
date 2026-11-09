import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/services/auth_service.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_list_view.dart';

class PrimeiroAcessoView extends StatefulWidget {
  const PrimeiroAcessoView({super.key});

  @override
  State<PrimeiroAcessoView> createState() =>
      _PrimeiroAcessoViewState();
}

class _PrimeiroAcessoViewState extends State<PrimeiroAcessoView> {
  // Controladores dos campos.
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Chave para validar o formulário.
  final _formKey = GlobalKey<FormState>();

  // Controla o estado do botão durante o cadastro.
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // Valida os dados e cadastra o usuário no Firebase.
  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // Envia os dados para o Firebase.
      await AuthService().cadastrar(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
      );

      if (!mounted) return;

      // Cadastro concluído.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
        ),
      );

      // Encaminha para a lista de clientes, limpando a pilha para que
      // o botão voltar não retorne ao login com a conta já aberta.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ClienteListView(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (erro) {
      if (!mounted) return;

      String mensagem;

      switch (erro.code) {
        case 'email-already-in-use':
          mensagem = 'Este e-mail já está cadastrado.';
          break;
        case 'invalid-email':
          mensagem = 'O endereço de e-mail é inválido.';
          break;
        case 'weak-password':
          mensagem = 'A senha é muito fraca.';
          break;
        case 'operation-not-allowed':
          mensagem = 'O cadastro por e-mail não está habilitado no Firebase.';
          break;
        case 'network-request-failed':
          mensagem = 'Verifique sua conexão com a internet.';
          break;
        default:
          mensagem = 'Erro ao cadastrar: ${erro.message ?? erro.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } on FirebaseException catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar os dados: ${erro.message ?? erro.code}'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro inesperado: $erro'),
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

  @override
  Widget build(BuildContext context) {
    return Fundopadrao(
      conteudo: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Primeiro acesso'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 34,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Criar conta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Preencha seus dados para acessar o sistema.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Nome completo.
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // E-mail.
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!valor.contains('@') || !valor.contains('.')) {
                      return 'Informe um e-mail válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Senha.
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe uma senha.';
                    }

                    if (valor.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirmação da senha.
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Confirme sua senha.';
                    }

                    if (valor != _senhaController.text) {
                      return 'As senhas não são iguais.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Botão de cadastro.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: _carregando ? null : _cadastrar,
                    child: _carregando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Cadastrar e continuar'),
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
      ),
    );
  }
}
