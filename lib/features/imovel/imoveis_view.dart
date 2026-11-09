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
  num? _valorMaximoFiltro;

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
          backgroundColor: Colors.transparent,
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
          if (_tipoFiltro != null ||
              _negociacaoFiltro != null ||
              _statusFiltro != null ||
              _valorMaximoFiltro != null) ...[
            ActionChip(
              avatar: const Icon(Icons.close, size: 16),
              label: const Text('Limpar'),
              onPressed: () {
                setState(() {
                  _tipoFiltro = null;
                  _negociacaoFiltro = null;
                  _statusFiltro = null;
                  _valorMaximoFiltro = null;
                });
              },
            ),
            const SizedBox(width: 8),
          ],

          // Filtro por Aluguel
          FilterChip(
            label: const Text('Aluguel'),
            selected: _negociacaoFiltro == NegociacaoImovel.aluguel,
            onSelected: (selecionado) {
              setState(() {
                _negociacaoFiltro = selecionado
                    ? NegociacaoImovel.aluguel
                    : null;
              });
            },
          ),
          const SizedBox(width: 8),

          // Filtro por Venda
          FilterChip(
            label: const Text('Venda'),
            selected: _negociacaoFiltro == NegociacaoImovel.venda,
            onSelected: (selecionado) {
              setState(() {
                _negociacaoFiltro = selecionado ? NegociacaoImovel.venda : null;
              });
            },
          ),
          const SizedBox(width: 8),

          // Filtro por Casas
          FilterChip(
            label: const Text('Casas'),
            selected: _tipoFiltro == TipoImovel.casa,
            onSelected: (selecionado) {
              setState(() {
                _tipoFiltro = selecionado ? TipoImovel.casa : null;
              });
            },
          ),
          const SizedBox(width: 8),

          // Filtro por Apartamentos
          FilterChip(
            label: const Text('Apartamentos'),
            selected: _tipoFiltro == TipoImovel.apartamento,
            onSelected: (selecionado) {
              setState(() {
                _tipoFiltro = selecionado ? TipoImovel.apartamento : null;
              });
            },
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
                ? cores.secondaryContainer
                : null,
            onPressed: () => _abrirDialogoValorMaximo(context),
          ),
        ],
      ),
    );
  }
}
