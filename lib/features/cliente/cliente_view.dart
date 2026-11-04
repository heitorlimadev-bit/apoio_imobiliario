import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';

class ClienteView extends StatefulWidget {
  final ClienteModel cliente;

  const ClienteView({super.key, required this.cliente});

  @override
  State<ClienteView> createState() => _ClienteViewState();
}

class _ClienteViewState extends State<ClienteView> {
  late final TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cliente.nome)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(widget.cliente.email),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Telefone'),
            subtitle: Text(widget.cliente.telefone),
          ),
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text('Etapa financiamento'),
            subtitle: Text(widget.cliente.etapaFinanciamento.rotulo),
          ),
          ListTile(
            leading: const Icon(Icons.savings),
            title: const Text('Capital próprio'),
            subtitle: Text(
              'R\$ ${widget.cliente.capitalProprio.toStringAsFixed(2).replaceAll('.', ',')}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Carta de crédito'),
            subtitle: Text(
              'R\$ ${widget.cliente.cartaCredito.toStringAsFixed(2).replaceAll('.', ',')}',
            ),
          ),
        ],
      ),
    );
  }
}
