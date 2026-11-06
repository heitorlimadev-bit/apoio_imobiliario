
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';
import 'package:apoio_imobiliario/features/cliente/selecionar_contato_view.dart';

class ClienteFormView extends StatefulWidget {
  final ClienteController controller;
  final ClienteModel? cliente;

  // Etapa recebida da tela de listagem.
  final EtapaFinanciamento etapaInicial;

  const ClienteFormView({
    super.key,
    required this.controller,
    this.cliente,
    this.etapaInicial = EtapaFinanciamento.montagemDePasta,
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

  bool _salvando = false;

  bool get _editando => widget.cliente != null;

  EtapaFinanciamento get _etapaAtual =>
      widget.cliente?.etapaFinanciamento ?? widget.etapaInicial;

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
      text: cliente == null || cliente.capitalProprio == 0
          ? ''
          : cliente.capitalProprio.toString(),
    );

    _cartaController = TextEditingController(
      text: cliente == null || cliente.cartaCredito == 0
          ? ''
          : cliente.cartaCredito.toString(),
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

  // IMPORTAÇÃO DE CONTATO DO CELULAR
  Future<void> _importarContato() async {
    try {
      final contato = await Navigator.push<Contact>(
        context,
        MaterialPageRoute(
          builder: (context) => const SelecionarContatoView(),
        ),
      );

      if (!mounted || contato == null) return;

      setState(() {
        _nomeController.text = contato.displayName ?? '';

        if (contato.phones.isNotEmpty) {
          _telefoneController.text =
              contato.phones.first.number;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato importado com sucesso!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao importar contato: $erro'),
        ),
      );
    }
  }

  // VALIDAÇÃO DO NOME
  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome do cliente.';
    }

    if (valor.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres.';
    }

    return null;
  }

  // VALIDAÇÃO DO E-MAIL
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

  // VALIDAÇÃO DO TELEFONE
  String? _validarTelefone(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o telefone.';
    }

    final numeros = valor.replaceAll(RegExp(r'\D'), '');

    if (numeros.length < 10 || numeros.length > 13) {
      return 'Informe um telefone válido com DDD.';
    }

    return null;
  }

  // VALIDAÇÃO DOS VALORES MONETÁRIOS
  String? _validarValor(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }

    if (int.tryParse(valor.trim()) == null) {
      return 'Informe um valor válido.';
    }

    return null;
  }

  // SALVAR CLIENTE NO FIREBASE
  Future<void> _salvar() async {
    if (_salvando) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _salvando = true;
    });

    try {
      final clienteAnterior = widget.cliente;

      final cliente = ClienteModel(
        id: clienteAnterior?.id ?? '',
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        capitalProprio: int.parse(_capitalController.text.trim()),
        cartaCredito: int.parse(_cartaController.text.trim()),
        etapaFinanciamento: _etapaAtual,
      );

      if (_editando) {
        await widget.controller.atualizar(cliente);
      } else {
        await widget.controller.adicionar(cliente);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Cliente atualizado com sucesso!'
                : 'Cliente cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar cliente: $erro'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  // CAMPO DE TEXTO PADRONIZADO
  Widget _campo({
    required String label,
    required IconData icone,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction inputAction = TextInputAction.next,
    List<TextInputFormatter>? formatters,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      inputFormatters: formatters,
      textCapitalization: capitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onFieldSubmitted: inputAction == TextInputAction.done
          ? (_) => _salvar()
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar cliente' : 'Novo cliente',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    Icon(
                      _editando
                          ? Icons.person_outline
                          : Icons.person_add_alt_1,
                      size: 55,
                      color: tema.colorScheme.primary,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _editando
                          ? 'Editar dados do cliente'
                          : 'Cadastrar cliente',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _editando
                          ? 'Atualize as informações do cliente.'
                          : 'Preencha os dados para cadastrar um novo cliente.',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 24),

                    // ETAPA DE FINANCIAMENTO
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.timeline),
                        title: const Text('Etapa de financiamento'),
                        subtitle: Text(_etapaAtual.rotulo),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // IMPORTAR CONTATO
                    if (!_editando) ...[
                      OutlinedButton.icon(
                        onPressed: _importarContato,
                        icon: const Icon(Icons.contacts_outlined),
                        label: const Text(
                          'Importar contato do celular',
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],

                    // NOME
                    _campo(
                      label: 'Nome completo',
                      icone: Icons.person_outline,
                      controller: _nomeController,
                      validator: _validarNome,
                      capitalization: TextCapitalization.words,
                    ),

                    const SizedBox(height: 18),

                    // E-MAIL
                    _campo(
                      label: 'E-mail',
                      icone: Icons.email_outlined,
                      controller: _emailController,
                      validator: _validarEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

                    // TELEFONE
                    _campo(
                      label: 'Telefone',
                      icone: Icons.phone_outlined,
                      controller: _telefoneController,
                      validator: _validarTelefone,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 18),

                    // CAPITAL PRÓPRIO
                    _campo(
                      label: 'Capital próprio',
                      icone: Icons.savings_outlined,
                      controller: _capitalController,
                      validator: (valor) => _validarValor(
                        valor,
                        'o capital próprio',
                      ),
                      keyboardType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),

                    const SizedBox(height: 18),

                    // CARTA DE CRÉDITO
                    _campo(
                      label: 'Carta de crédito',
                      icone: Icons.account_balance_outlined,
                      controller: _cartaController,
                      validator: (valor) => _validarValor(
                        valor,
                        'a carta de crédito',
                      ),
                      keyboardType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),

                    const SizedBox(height: 30),

                    // BOTÃO SALVAR
                    FilledButton.icon(
                      onPressed: _salvando ? null : _salvar,

                      icon: _salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              _editando
                                  ? Icons.save_outlined
                                  : Icons.person_add_alt_1,
                            ),

                      label: Text(
                        _salvando
                            ? 'Salvando...'
                            : _editando
                                ? 'Salvar alterações'
                                : 'Cadastrar cliente',
                      ),

                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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
