
import 'package:flutter/material.dart';

import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_form_view.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_view.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

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

  EtapaFinanciamento _statusAtual =
      EtapaFinanciamento.montagemDePasta;

  // Abre o formulário para cadastrar um cliente.
  Future<void> _adicionarCliente() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteFormView(
          controller: _controller,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado != null) {
      setState(() {
        _statusAtual = EtapaFinanciamento.montagemDePasta;
      });
    }
  }

  // Abre os detalhes do cliente.
  Future<void> _abrirCliente(cliente) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteView(
          cliente: cliente,
          controller: _controller,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    final clientesFiltrados =
        _controller.listarPorEtapa(_statusAtual);

    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Apoio Imobiliário'),
        ),

        // Botão para cadastrar clientes.
        floatingActionButton: FloatingActionButton(
          onPressed: _adicionarCliente,
          tooltip: 'Adicionar cliente',
          child: const Icon(Icons.add),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botões para selecionar as etapas.
            LayoutBuilder(
              builder: (context, limites) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: limites.maxWidth - 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final etapa in EtapaFinanciamento.values)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: etapa == _statusAtual
                                  ? cores.primary
                                  : cores.surfaceContainerHigh,
                              foregroundColor: etapa == _statusAtual
                                  ? cores.onPrimary
                                  : cores.onSurfaceVariant,
                              minimumSize: const Size(52, 48),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _statusAtual = etapa;
                              });
                            },
                            child: Icon(
                              _iconeDaEtapa(etapa),
                              size: 22,
                            ),
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

            // Lista de clientes da etapa selecionada.
            Expanded(
              child: clientesFiltrados.isEmpty
                  ? const Center(
                      child: Text('Nenhum cliente nesta etapa.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 80,
                      ),
                      itemCount: clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = clientesFiltrados[index];

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cores.primaryContainer,
                              foregroundColor: cores.onPrimaryContainer,
                              child: const Icon(
                                Icons.face,
                                size: 22,
                              ),
                            ),
                            title: Text(cliente.nome),
                            subtitle: Text(cliente.email),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: cores.onSurfaceVariant,
                            ),
                            onTap: () => _abrirCliente(cliente),
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
