import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:flutter/services.dart';

import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteFormView extends StatefulWidget {
  final ClienteController controller;
  final ClienteModel? cliente;
  final EtapaFinanciamento etapaInicial;

  const ClienteFormView({
    super.key,
    required this.controller,
    this.cliente,
    this.etapaInicial =
        EtapaFinanciamento.montagemDePasta,
  });

  @override
  State<ClienteFormView> createState() =>
      _ClienteFormViewState();
}

class _ClienteFormViewState extends State<ClienteFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nome;
  late final TextEditingController _email;
  late final TextEditingController _telefone;
  late final TextEditingController _capital;
  late final TextEditingController _carta;

  bool _salvando = false;

  bool get _editando => widget.cliente != null;

  EtapaFinanciamento get _etapa =>
      widget.cliente?.etapaFinanciamento ??
      widget.etapaInicial;

  @override
  void initState() {
    super.initState();

    final c = widget.cliente;

    _nome = TextEditingController(text: c?.nome ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _telefone =
        TextEditingController(text: c?.telefone ?? '');

    _capital = TextEditingController(
      text: c == null || c.capitalProprio == 0
          ? ''
          : '${c.capitalProprio}',
    );

    _carta = TextEditingController(
      text: c == null || c.cartaCredito == 0
          ? ''
          : '${c.cartaCredito}',
    );
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _capital.dispose();
    _carta.dispose();

    super.dispose();
  }

  String? _validarNome(String? v) {
    if (v == null || v.trim().length < 3) {
      return 'Informe um nome com pelo menos 3 caracteres.';
    }

    return null;
  }

  String? _validarEmail(String? v) {
    if (v == null ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(v.trim())) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  String? _validarTelefone(String? v) {
    final n = (v ?? '').replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (n.length < 10 || n.length > 13) {
      return 'Informe um telefone válido com DDD.';
    }

    return null;
  }

  String? _validarNumero(String? v, String campo) {
    if (v == null || int.tryParse(v.trim()) == null) {
      return 'Informe $campo válido.';
    }

    return null;
  }

  // Importar contato da agenda.

  // Salvar no Firebase.
  Future<void> _salvar() async {
    if (_salvando ||
        !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _salvando = true;
    });

    try {
      final anterior = widget.cliente;

      final cliente = ClienteModel(
        id: anterior?.id ?? '',
        nome: _nome.text.trim(),
        email: _email.text.trim(),
        telefone: _telefone.text.trim(),
        capitalProprio:
            int.parse(_capital.text.trim()),
        cartaCredito:
            int.parse(_carta.text.trim()),
        etapaFinanciamento: _etapa,
      );

      late final ClienteModel salvo;

      if (_editando) {
        await widget.controller.atualizar(cliente);
        salvo = cliente;
      } else {
        salvo = await widget.controller.adicionar(cliente);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Cliente atualizado no Firebase!'
                : 'Cliente salvo no Firebase!',
          ),
        ),
      );

      Navigator.pop(context, salvo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível salvar no Firebase: $e',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  Widget _campo(
    String titulo,
    IconData icone,
    TextEditingController c,
    String? Function(String?) validar, {
    TextInputType tipo = TextInputType.text,
    List<TextInputFormatter>? formatters,
    TextCapitalization capitalizacao =
        TextCapitalization.none,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: tipo,
      inputFormatters: formatters,
      textCapitalization: capitalizacao,
      validator: validar,
      decoration: InputDecoration(
        labelText: titulo,
        prefixIcon: Icon(icone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Fundopadrao(
      conteudo: Scaffold(
      backgroundColor: Colors.transparent,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

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

                    const SizedBox(height: 20),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.timeline),
                        title: const Text(
                          'Etapa de financiamento',
                        ),
                        subtitle: Text(_etapa.rotulo),
                      ),
                    ),


                    _campo(
                      'Nome completo',
                      Icons.person_outline,
                      _nome,
                      _validarNome,
                      capitalizacao:
                          TextCapitalization.words,
                    ),

                    const SizedBox(height: 16),

                    _campo(
                      'E-mail',
                      Icons.email_outlined,
                      _email,
                      _validarEmail,
                      tipo: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    _campo(
                      'Telefone',
                      Icons.phone_outlined,
                      _telefone,
                      _validarTelefone,
                      tipo: TextInputType.phone,
                    ),

                    const SizedBox(height: 16),

                    _campo(
                      'Capital próprio (R\$)',
                      Icons.savings_outlined,
                      _capital,
                      (v) => _validarNumero(
                        v,
                        'o capital próprio',
                      ),
                      tipo: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),

                    const SizedBox(height: 16),

                    _campo(
                      'Carta de crédito (R\$)',
                      Icons.account_balance_outlined,
                      _carta,
                      (v) => _validarNumero(
                        v,
                        'a carta de crédito',
                      ),
                      tipo: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),

                    const SizedBox(height: 28),

                    FilledButton.icon(
                      onPressed:
                          _salvando ? null : _salvar,
                      icon: _salvando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
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
                        minimumSize:
                            const Size(double.infinity, 52),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}