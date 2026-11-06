
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteFormView extends StatefulWidget {
  final ClienteController controller;
  final ClienteModel? cliente;

  const ClienteFormView({
    super.key,
    required this.controller,
    this.cliente,
  });

  @override
  State<ClienteFormView> createState() => _ClienteFormViewState();
}

class _ClienteFormViewState extends State<ClienteFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _capitalController;
  late final TextEditingController _cartaController;

  bool get _editando => widget.cliente != null;

  @override
  void initState() {
    super.initState();

    final cliente = widget.cliente;

    _nomeController = TextEditingController(
      text: cliente?.nome ?? '',
    );

    _emailController = TextEditingController(
      text: cliente?.email ?? '',
    );

    _telefoneController = TextEditingController(
      text: cliente?.telefone ?? '',
    );

    _capitalController = TextEditingController(
      text: cliente?.capitalProprio.toString() ?? '',
    );

    _cartaController = TextEditingController(
      text: cliente?.cartaCredito.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _capitalController.dispose();
    _cartaController.dispose();

    super.dispose();
  }

  // Valida os dados e salva o cliente.
  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final clienteAnterior = widget.cliente;

    final cliente = ClienteModel(
      id: clienteAnterior?.id ?? 0,
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      capitalProprio: int.parse(_capitalController.text),
      cartaCredito: int.parse(_cartaController.text),
      etapaFinanciamento: clienteAnterior?.etapaFinanciamento ??
          EtapaFinanciamento.montagemDePasta,
    );

    final ClienteModel resultado;

    if (_editando) {
      widget.controller.atualizar(cliente);
      resultado = cliente;
    } else {
      resultado = widget.controller.adicionar(cliente);
    }

    Navigator.pop(context, resultado);
  }

  // Valida se o e-mail possui um formato básico válido.
  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail.';
    }

    final emailValido = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(valor.trim());

    if (!emailValido) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  // Valida campos numéricos.
  String? _validarNumero(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }

    if (int.tryParse(valor) == null) {
      return 'Informe um valor numérico válido.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar cliente' : 'Novo cliente',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 55,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _editando ? 'Editar dados do cliente' : 'Cadastrar cliente',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 28),

                  // Nome.
                  TextFormField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o nome do cliente.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // E-mail.
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validarEmail,
                  ),

                  const SizedBox(height: 16),

                  // Telefone.
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o telefone.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Capital próprio.
                  TextFormField(
                    controller: _capitalController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Capital próprio (R\$)',
                      prefixIcon: Icon(Icons.savings_outlined),
                    ),
                    validator: (valor) =>
                        _validarNumero(valor, 'o capital próprio'),
                  ),

                  const SizedBox(height: 16),

                  // Carta de crédito.
                  TextFormField(
                    controller: _cartaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _salvar(),
                    decoration: const InputDecoration(
                      labelText: 'Carta de crédito (R\$)',
                      prefixIcon: Icon(Icons.account_balance_outlined),
                    ),
                    validator: (valor) =>
                        _validarNumero(valor, 'a carta de crédito'),
                  ),

                  const SizedBox(height: 28),

                  FilledButton.icon(
                    onPressed: _salvar,
                    icon: Icon(
                      _editando ? Icons.save_outlined : Icons.person_add,
                    ),
                    label: Text(
                      _editando ? 'Salvar alterações' : 'Cadastrar cliente',
                    ),
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
