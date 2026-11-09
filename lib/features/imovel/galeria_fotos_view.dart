import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';

import 'imovel_imagens.dart';

/// Tela/galeria para o usuário escolher a foto do imóvel
/// a partir das imagens internas do app (assets).
class GaleriaFotosView extends StatefulWidget {
  /// Caminho da foto já selecionada (se houver).
  final String? fotoAtual;

  const GaleriaFotosView({
    super.key,
    this.fotoAtual,
  });

  @override
  State<GaleriaFotosView> createState() => _GaleriaFotosViewState();
}

class _GaleriaFotosViewState extends State<GaleriaFotosView> {
  String? _selecionada;
  String _filtroTipo = 'Todos';

  static const _tipos = [
    'Todos',
    'Casa',
    'Apartamento',
    'Terreno',
    'Comercial',
  ];

  @override
  void initState() {
    super.initState();
    _selecionada = widget.fotoAtual;
  }

  List<Map<String, String>> get _imagensFiltradas {
    if (_filtroTipo == 'Todos') {
      return ImovelImagens.imagens;
    }
    return ImovelImagens.imagens
        .where((img) => img['tipo'] == _filtroTipo)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final imagens = _imagensFiltradas;

    return Fundopadrao(
      conteudo: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Galeria de fotos'),
        actions: [
          TextButton(
            onPressed: _selecionada == null
                ? null
                : () => Navigator.pop(context, _selecionada),
            child: const Text('Confirmar'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro por tipo
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _tipos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tipo = _tipos[index];
                final ativo = tipo == _filtroTipo;
                return FilterChip(
                  label: Text(tipo),
                  selected: ativo,
                  onSelected: (_) {
                    setState(() => _filtroTipo = tipo);
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Grade de fotos
          Expanded(
            child: imagens.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma foto neste filtro.',
                      style: TextStyle(color: cores.onSurfaceVariant),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: imagens.length,
                    itemBuilder: (context, index) {
                      final item = imagens[index];
                      final caminho = item['caminho']!;
                      final nome = item['nome']!;
                      final selecionada = _selecionada == caminho;

                      return InkWell(
                        onTap: () {
                          setState(() => _selecionada = caminho);
                        },
                        onDoubleTap: () {
                          Navigator.pop(context, caminho);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selecionada
                                  ? cores.primary
                                  : cores.outlineVariant,
                              width: selecionada ? 3 : 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                caminho,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => ColoredBox(
                                  color: cores.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: cores.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    20,
                                    8,
                                    8,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    nome,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              if (selecionada)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: cores.primary,
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: cores.onPrimary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _selecionada == null
                ? null
                : () => Navigator.pop(context, _selecionada),
            icon: const Icon(Icons.check),
            label: Text(
              _selecionada == null
                  ? 'Selecione uma foto'
                  : 'Usar foto selecionada',
            ),
          ),
        ),
      ),
      ),
    );
  }
}