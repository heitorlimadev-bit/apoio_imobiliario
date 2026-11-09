import 'package:flutter/material.dart';

import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_form_view.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_view.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';
import 'package:apoio_imobiliario/features/cliente/importar_contatos_view.dart';
import 'package:apoio_imobiliario/features/imovel/imoveis_view.dart';
import 'package:apoio_imobiliario/features/login/login_view.dart';
import 'package:apoio_imobiliario/services/auth_service.dart';

class ClienteListView extends StatefulWidget {
  const ClienteListView({super.key});

  @override
  State<ClienteListView> createState() => _ClienteListViewState();
}

IconData _iconeDaEtapa(EtapaFinanciamento etapa) {
  return switch (etapa) {
    EtapaFinanciamento.montagemDePasta => Icons.folder_open,
    EtapaFinanciamento.analiseDeCredito => Icons.manage_search,
    EtapaFinanciamento.creditoAprovado => Icons.check_circle,
    EtapaFinanciamento.creditoReprovado => Icons.cancel,
    EtapaFinanciamento.engenharia => Icons.engineering,
    EtapaFinanciamento.assinaturaDeContrato => Icons.draw,
  };
}

class _ClienteListViewState extends State<ClienteListView> {
  final _controller = ClienteController();

  EtapaFinanciamento _statusAtual =
      EtapaFinanciamento.montagemDePasta;

  // Criado uma única vez: se ficasse no build, cada troca de etapa
  // reabriria a escuta no Firestore e piscaria o carregamento.
  late final Stream<List<ClienteModel>> _clientesStream;

  @override
  void initState() {
    super.initState();
    _clientesStream = _controller.observarClientes();
  }

  Future<void> _abrirImoveis() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ImoveisView(),
      ),
    );
  }

  Future<void> _importarDaAgenda() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImportarContatosView(
          controller: _controller,
          etapaInicial: _statusAtual,
        ),
      ),
    );
  }

  // Adicionar cliente.
  Future<void> _adicionarCliente() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteFormView(
          controller: _controller,
          etapaInicial: _statusAtual,
        ),
      ),
    );
  }

  // Abrir detalhes do cliente.
  Future<void> _abrirCliente(ClienteModel cliente) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteView(
          cliente: cliente,
          controller: _controller,
        ),
      ),
    );
  }

  Future<void> _deslogar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Deseja realmente sair para entrar com outra conta de corretor?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await AuthService().logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginView(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair da conta: $e'),
        ),
      );
    }
  }

  // Alterar etapa deslizando o cliente.
  Future<bool> _deslizarCliente(
    ClienteModel cliente,
    DismissDirection direcao,
  ) async {
    final EtapaFinanciamento? destino =
        direcao == DismissDirection.startToEnd
            ? cliente.etapaFinanciamento.seguinte
            : cliente.etapaFinanciamento.anterior;

    // Verifica se existe uma próxima etapa.
    if (destino == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não existem mais etapas nessa direção.',
            ),
          ),
        );
      }

      return false;
    }

    try {
      await _controller.alterarEtapa(cliente, destino);

      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${cliente.nome} movido para ${destino.rotulo}.',
          ),
        ),
      );

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível mudar a etapa: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Apoio Imobiliário'),
          actions: [
            IconButton(
              onPressed: _abrirImoveis,
              icon: const Icon(Icons.home_work_outlined),
              tooltip: 'Imóveis',
            ),
            IconButton(
              onPressed: _deslogar,
              icon: const Icon(Icons.logout),
              tooltip: 'Sair da conta',
            ),
            const SizedBox(width: 8),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final opcao = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Cadastrar manualmente'),
                      onTap: () => Navigator.pop(context, 'manual'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.import_contacts),
                      title: const Text('Importar da agenda'),
                      onTap: () => Navigator.pop(context, 'agenda'),
                    ),
                  ],
                ),
              ),
            );

            if (opcao == 'manual') {
              await _adicionarCliente();
            } else if (opcao == 'agenda') {
              await _importarDaAgenda();
            }
          },
          tooltip: 'Adicionar cliente',
          child: const Icon(Icons.add),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seleção das etapas.
            LayoutBuilder(
              builder: (context, limites) {
                return SingleChildScrollView(
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
                        for (final etapa
                            in EtapaFinanciamento.values)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    etapa == _statusAtual
                                        ? cores.primary
                                        : cores.surfaceContainerHigh,
                                foregroundColor:
                                    etapa == _statusAtual
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
                );
              },
            ),

            // Nome da etapa selecionada.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                8,
              ),
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

            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'Deslize para a direita: próxima etapa'
                ' • para a esquerda: etapa anterior',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),

            // Clientes carregados do Firestore.
            Expanded(
              child: StreamBuilder<List<ClienteModel>>(
                stream: _clientesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Erro ao carregar clientes do Firebase:\n'
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final clientes = snapshot.data!
                      .where(
                        (cliente) =>
                            cliente.etapaFinanciamento ==
                            _statusAtual,
                      )
                      .toList();

                  if (clientes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum cliente nesta etapa.',
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 80,
                    ),
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];

                      return Dismissible(
                        key: ValueKey(cliente.id),
                        direction: DismissDirection.horizontal,

                        // Fundo ao deslizar para a direita.
                        background: Container(
                          color: Colors.green.withValues(alpha: .12),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            left: 24,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.green,
                          ),
                        ),

                        // Fundo ao deslizar para a esquerda.
                        secondaryBackground: Container(
                          color: Colors.orange.withValues(alpha: .12),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(
                            right: 24,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.orange,
                          ),
                        ),

                        confirmDismiss: (direction) =>
                            _deslizarCliente(
                          cliente,
                          direction,
                        ),

                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  cores.primaryContainer,
                              foregroundColor:
                                  cores.onPrimaryContainer,
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
                        ),
                      );
                    },
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
