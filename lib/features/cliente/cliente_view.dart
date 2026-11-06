
import 'package:flutter/material.dart';

import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_form_view.dart';

class ClienteView extends StatefulWidget {
  final ClienteModel cliente;
  final ClienteController? controller;

  const ClienteView({
    super.key,
    required this.cliente,
    this.controller,
  });

  @override
  State<ClienteView> createState() => _ClienteViewState();
}

class _ClienteViewState extends State<ClienteView> {
  late ClienteModel _cliente;

  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
  }

  // Abre o formulário no modo de edição.
  Future<void> _editarCliente() async {
    final controller = widget.controller;

    if (controller == null) return;

    final resultado = await Navigator.push<ClienteModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteFormView(
          controller: controller,
          cliente: _cliente,
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    setState(() {
      _cliente = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_cliente.nome),
          actions: [
            if (widget.controller != null)
              IconButton(
                onPressed: _editarCliente,
                tooltip: 'Editar cliente',
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Nome'),
                      subtitle: Text(_cliente.nome),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('E-mail'),
                      subtitle: Text(_cliente.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_android),
                      title: const Text('Telefone'),
                      subtitle: Text(_cliente.telefone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.timeline),
                      title: const Text('Etapa financiamento'),
                      subtitle: Text(
                        _cliente.etapaFinanciamento.rotulo,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.savings),
                      title: const Text('Capital próprio'),
                      subtitle: Text(
                        'R\$ ${_cliente.capitalProprio.toStringAsFixed(2).replaceAll('.', ',')}',
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: const Text('Carta de crédito'),
                      subtitle: Text(
                        'R\$ ${_cliente.cartaCredito.toStringAsFixed(2).replaceAll('.', ',')}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
