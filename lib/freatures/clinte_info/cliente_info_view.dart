
import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/freatures/clinte_info/etapa_financialmento.dart';
import 'cliente_info_model.dart';

class ClienteInfo extends StatefulWidget {
  const ClienteInfo({super.key});

  @override
  State<ClienteInfo> createState() => _ClienteInfoState();
}

class _ClienteInfoState extends State<ClienteInfo> {
  EtapaFinancialmento statusAtual =
      EtapaFinancialmento.montagemDePasta;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Filtra os clientes pela etapa selecionada.
    final clientesFiltrados = clientes.where((cliente) {
      return cliente.etapaFinancialmento == statusAtual;
    }).toList();

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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.montagemDePasta;
                    });
                  },
                  child: const Icon(Icons.folder_open),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.analiseDeCredito;
                    });
                  },
                  child: const Icon(Icons.manage_search),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.creditoAprovado;
                    });
                  },
                  child: const Icon(Icons.check_circle),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.creditoReprovado;
                    });
                  },
                  child: const Icon(Icons.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.engenharia;
                    });
                  },
                  child: const Icon(Icons.engineering),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusAtual =
                          EtapaFinancialmento.assinaturaDeContrato;
                    });
                  },
                  child: const Icon(Icons.draw),
                ),
              ],
            ),
          ),

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
