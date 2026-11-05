import 'package:apoio_imobiliario/features/cliente/cliente_view.dart';
import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
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
  EtapaFinanciamento _statusAtual = EtapaFinanciamento.montagemDePasta;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Filtra os clientes pela etapa selecionada.

    final clientesFiltrados = _controller.listarPorEtapa(_statusAtual);

    return Fundopadrao(
      conteudo: Scaffold(
      backgroundColor: Colors.transparent, // deixa o fundo padrão aparecer
      appBar: AppBar(
        title: const Text('Apoio Imobiliario'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Botões para selecionar as etapas.
          LayoutBuilder(
            builder: (context, limites) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ConstrainedBox(
              // Centraliza quando cabe na tela; rola quando não cabe
              constraints: BoxConstraints(minWidth: limites.maxWidth - 24),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final etapa in EtapaFinanciamento.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: etapa == _statusAtual
                            ? cores.primary
                            : cores.surfaceContainerHigh,
                        foregroundColor: (etapa == _statusAtual
                            ? cores.onPrimary
                            : cores.onSurfaceVariant),
                        minimumSize: const Size(52, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          _statusAtual = etapa;
                        });
                      },
                      child: Icon(_iconeDaEtapa(etapa), size: 22),
                    ),
                  ),
              ],
            ),
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              _statusAtual.rotulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // A lista ocupa o espaço restante da tela.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              itemCount: clientesFiltrados.length,
              itemBuilder: (context, index) {
                final cliente = clientesFiltrados[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cores.primaryContainer,
                      foregroundColor: cores.onPrimaryContainer,
                      child: const Icon(Icons.face, size: 22),
                    ),
                    title: Text(cliente.nome),
                    subtitle: Text(cliente.email),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: cores.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClienteView(cliente: cliente),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
