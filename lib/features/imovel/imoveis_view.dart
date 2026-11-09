import 'package:apoio_imobiliario/features/imovel/imovel_model.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';
import 'package:flutter/material.dart';

import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'imovel_controller.dart';
import 'imovel_card.dart';
import 'imovel_form_novoimovel.dart';

class ImoveisView extends StatefulWidget {
  const ImoveisView({super.key});

  @override
  State<ImoveisView> createState() => _ImoveisViewState();
}

class _ImoveisViewState extends State<ImoveisView> {
  //variáveis de estado para seleções dos filtros
  TipoImovel? _tipoFiltro;
  NegociacaoImovel? _negociacaoFiltro;
  StatusImovel? _statusFiltro;
  int? _quartosMinimoFiltro; // ex.: 2 = "2 ou mais quartos"
  num? _valorMaximoFiltro;

  bool get _temFiltroAtivo =>
      _tipoFiltro != null ||
      _negociacaoFiltro != null ||
      _statusFiltro != null ||
      _quartosMinimoFiltro != null ||
      _valorMaximoFiltro != null;

  final _controller = ImovelController();

  // O stream é criado uma única vez: recriá-lo a cada build (ex.: ao mudar
  // um filtro) abriria uma nova escuta no Firestore e piscaria o loading.
  late final Stream<List<ImovelModel>> _imoveisStream;

  @override
  void initState() {
    super.initState();
    _imoveisStream = _controller.observarImoveis();
  }

  // Aplica os filtros localmente sobre a lista que veio do Firestore.
  List<ImovelModel> _aplicarFiltros(List<ImovelModel> imoveis) {
    return imoveis.where((imovel) {
      //Se o filtro de tipo estiver preenchido, validara correspondencia
      if (_tipoFiltro != null && imovel.tipoImovel != _tipoFiltro) {
        return false;
      }
      //filtro negociação (Aluguel, venda, troca)
      if (_negociacaoFiltro != null &&
          imovel.negociacaoImovel != _negociacaoFiltro) {
        return false;
      }
      //filtro por status (disponível, vendido, etc)
      if (_statusFiltro != null && imovel.statusImovel != _statusFiltro) {
        return false;
      }
      //filtro por quantidade mínima de quartos
      if (_quartosMinimoFiltro != null &&
          imovel.qtDormitorios < _quartosMinimoFiltro!) {
        return false;
      }
      //filtro por teto de preço
      if (_valorMaximoFiltro != null && imovel.valor > _valorMaximoFiltro!) {
        return false;
      }
      return true;
    }).toList();
  }

  void _abrirDialogoValorMaximo(BuildContext context) {
    final controller = TextEditingController(
      text: _valorMaximoFiltro != null
          ? _valorMaximoFiltro!.toInt().toString()
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filtrar por valor máximo'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: 'R\$ ',
            labelText: 'Valor limite',
            hintText: 'Ex: 500000',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _valorMaximoFiltro = null);
              Navigator.pop(ctx);
            },
            child: const Text('Limpar'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = num.tryParse(
                controller.text.replaceAll(RegExp(r'[^0-9]'), ''),
              );
              setState(() => _valorMaximoFiltro = parsed);
              Navigator.pop(ctx);
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  Future<void> _cadastrarImovel() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroImovel(),
      ),
    );
  }

  Future<void> _editarImovel(ImovelModel imovel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroImovel(
          imovel: imovel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cores = theme.colorScheme;

    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Imóveis'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                tooltip: 'Cadastrar imóvel',
                style: IconButton.styleFrom(
                  backgroundColor: cores.primary,
                  foregroundColor: cores.onPrimary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(35, 35),
                  fixedSize: const Size(35, 35),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _cadastrarImovel,
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),

        body: Column(
          children: [
            // Barra de filtros horizontal fixa no topo
            _buildBarraFiltros(theme, cores),

            // Lista com rolagem ocupando o restante da tela
            Expanded(
              child: StreamBuilder<List<ImovelModel>>(
                stream: _imoveisStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint('Erro ao carregar imóveis: ${snapshot.error}');
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Erro ao carregar imóveis.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cores.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final imoveis = _aplicarFiltros(snapshot.data!);
                  if (imoveis.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum imóvel encontrado.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cores.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: imoveis.length,
                    itemBuilder: (context, index) {
                      final imovel = imoveis[index];
                      return ImovelCard(
                        imovel: imovel,
                        onEditar: () => _editarImovel(imovel),
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

  Widget _buildBarraFiltros(ThemeData theme, ColorScheme cores) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Botão Limpar (aparece apenas quando há algum filtro ativo)
          if (_temFiltroAtivo) ...[
            ActionChip(
              avatar: const Icon(Icons.close, size: 16),
              label: const Text('Limpar'),
              onPressed: () {
                setState(() {
                  _tipoFiltro = null;
                  _negociacaoFiltro = null;
                  _statusFiltro = null;
                  _quartosMinimoFiltro = null;
                  _valorMaximoFiltro = null;
                });
              },
            ),
            const SizedBox(width: 8),
          ],

          // Negociação: Aluguel, Venda, Troca...
          _filtroDropdown<NegociacaoImovel>(
            titulo: 'Negociação',
            icone: Icons.handshake_outlined,
            opcoes: NegociacaoImovel.values,
            selecionado: _negociacaoFiltro,
            rotulo: (n) => n.rotulo,
            aoSelecionar: (n) => setState(() => _negociacaoFiltro = n),
          ),
          const SizedBox(width: 8),

          // Tipo: Casa, Apartamento, Terreno...
          _filtroDropdown<TipoImovel>(
            titulo: 'Tipo',
            icone: Icons.home_work_outlined,
            opcoes: TipoImovel.values,
            selecionado: _tipoFiltro,
            rotulo: (t) => t.rotulo,
            aoSelecionar: (t) => setState(() => _tipoFiltro = t),
          ),
          const SizedBox(width: 8),

          // Quartos: mínimo de dormitórios (1+, 2+, 3+, 4+)
          _filtroDropdown<int>(
            titulo: 'Quartos',
            icone: Icons.bed_outlined,
            opcoes: const [1, 2, 3, 4],
            selecionado: _quartosMinimoFiltro,
            rotulo: (q) => '$q+ quartos',
            aoSelecionar: (q) => setState(() => _quartosMinimoFiltro = q),
          ),
          const SizedBox(width: 8),

          // Status: Disponível, Vendido, Alugado
          _filtroDropdown<StatusImovel>(
            titulo: 'Status',
            icone: Icons.flag_outlined,
            opcoes: StatusImovel.values,
            selecionado: _statusFiltro,
            rotulo: (s) => s.rotulo,
            aoSelecionar: (s) => setState(() => _statusFiltro = s),
          ),
          const SizedBox(width: 8),

          // Filtro por Preço Máximo
          ActionChip(
            avatar: const Icon(Icons.attach_money, size: 16),
            label: Text(
              _valorMaximoFiltro == null
                  ? 'Preço máximo'
                  : 'Até R\$ ${_valorMaximoFiltro!.toInt()}',
            ),
            backgroundColor: _valorMaximoFiltro != null
                ? cores.primaryContainer
                : null,
            onPressed: () => _abrirDialogoValorMaximo(context),
          ),
        ],
      ),
    );
  }

  /// Botão de filtro que, ao ser tocado, abre um menu com as opções.
  ///
  /// É genérico (`<T>`) para servir a qualquer lista de opções: enums
  /// (tipo, negociação, status) ou números (quartos). A primeira opção do
  /// menu, "Todos", remove o filtro. Quando há algo selecionado, o botão
  /// mostra o valor escolhido e fica destacado.
  Widget _filtroDropdown<T>({
    required String titulo,
    required IconData icone,
    required List<T> opcoes,
    required T? selecionado,
    required String Function(T) rotulo,
    required ValueChanged<T?> aoSelecionar,
  }) {
    final cores = Theme.of(context).colorScheme;
    final ativo = selecionado != null;

    // O menu trabalha com o índice da opção; -1 representa "Todos".
    // (O PopupMenuButton ignora seleções com valor null, por isso o índice.)
    return PopupMenuButton<int>(
      tooltip: 'Filtrar por $titulo',
      position: PopupMenuPosition.under,
      onSelected: (indice) =>
          aoSelecionar(indice < 0 ? null : opcoes[indice]),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: -1,
          child: Text('Todos (${titulo.toLowerCase()})'),
        ),
        const PopupMenuDivider(),
        for (var i = 0; i < opcoes.length; i++)
          CheckedPopupMenuItem(
            value: i,
            checked: opcoes[i] == selecionado,
            child: Text(rotulo(opcoes[i])),
          ),
      ],
      child: Chip(
        avatar: Icon(icone, size: 16),
        backgroundColor: ativo ? cores.primaryContainer : null,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ativo ? rotulo(selecionado as T) : titulo),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}
