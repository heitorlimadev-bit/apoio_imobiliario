
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
  final _controller = ImovelController();

  Future<void> _cadastrarImovel() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroImovel(),
      ),
    );
  }

  Future<void> _editarImovel(imovel) async {
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
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimary,
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
        body: StreamBuilder(
          stream: _controller.observarImoveis(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Erro ao carregar imóveis:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final imoveis = snapshot.data ?? [];

            if (imoveis.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.home_work_outlined,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Você ainda não possui imóveis cadastrados.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _cadastrarImovel,
                        icon: const Icon(Icons.add),
                        label: const Text('Cadastrar primeiro imóvel'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 24,
              ),
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
    );
  }
}
