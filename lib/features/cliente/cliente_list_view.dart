import 'package:apoio_imobiliario/features/cliente/cliente_view.dart';
import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';

class ClienteListView extends StatefulWidget {
  const ClienteListView({super.key});

  @override
  State<ClienteListView> createState() => _ClienteListViewState();
}

  IconData _iconeDaEtapa(EtapaFinanciamento etapa) => switch (etapa) {
    EtapaFinanciamento.montagemDePasta => Icons.folder_open,
    EtapaFinanciamento.analiseDeCredito => Icons.manage_search,
    EtapaFinanciamento.creditoAprovado => Icons.check_circle,
    EtapaFinanciamento.creditoReprovado => Icons.cancel,
    EtapaFinanciamento.engenharia => Icons.engineering,
    EtapaFinanciamento.assinaturaDeContrato => Icons.draw,
  };


class _ClienteListViewState extends State<ClienteListView> {
  final _controller = ClienteController();
  EtapaFinanciamento statusAtual = EtapaFinanciamento.montagemDePasta;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Filtra os clientes pela etapa selecionada.
  
    final clientesFiltrados = _controller.listarPorEtapa(statusAtual);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apoio Imobiliario'),
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
      ),
      body: Column(
        children: [
          // Botões para selecionar as etapas.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final etapa in EtapaFinanciamento.values)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: (etapa == statusAtual
                          ? cores.onSecondary
                          : cores.primary),
                    ),
                    onPressed: () {
                      setState(() {
                        statusAtual = etapa;
                      });
                    },
                    child: Icon(_iconeDaEtapa(etapa)),
                  ),
              ],
            ),
          ),
          Text(statusAtual.rotulo),
          // A lista ocupa o espaço restante da tela.
          Expanded(
            child: ListView.builder(
              itemCount: clientesFiltrados.length,
              itemBuilder: (context, index) {
                final cliente = clientesFiltrados[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.face),
                    title: Text(cliente.nome),
                    subtitle: Text(cliente.email),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteView(cliente: cliente),
                    )
                    );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
