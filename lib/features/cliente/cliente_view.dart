import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';

class ClienteView extends StatelessWidget {
  final ClienteModel cliente;

  const ClienteView({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cliente.nome)),
      body: ListView(
        children: [
          ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(cliente.email),
          ),
          ListTile(
          leading: const Icon(Icons.phone_android),
          title: const Text('Telefone'),
          subtitle: Text(cliente.telefone),
          ),
          ListTile(
          leading: const Icon(Icons.timeline),
          title: const Text('Etapa financiamento'),
          subtitle: Text(cliente.etapaFinanciamento.rotulo),
          ),
          ListTile(
          leading: const Icon(Icons.savings),
          title: const Text('Capital próprio'),
          subtitle: Text('R\$ ${cliente.capitalProprio.toStringAsFixed(2).replaceAll('.', ',')}'),
          ),
          ListTile(
          leading: const Icon(Icons.account_balance),
          title: const Text('Carta de crédito'),
          subtitle: Text('R\$ ${cliente.cartaCredito.toStringAsFixed(2).replaceAll('.', ',')}'),
          ),
          ],
      )
    );
  }
}
