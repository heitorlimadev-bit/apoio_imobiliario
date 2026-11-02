
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // Valida os dados e encaminha para a lista de clientes.
  void _cadastrar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ClienteListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeiro acesso'),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 60,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Criar conta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Preencha seus dados para acessar o sistema.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // Nome completo.
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!valor.contains('@') ||
                        !valor.contains('.')) {
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                    onPressed: _cadastrar,
                    child: const Text('Cadastrar e continuar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
