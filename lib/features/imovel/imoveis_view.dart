import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_card.dart'; // Ajuste o caminho
import 'package:apoio_imobiliario/features/imovel/imovel_mock.dart'; // Seu mock de imóveis
import 'package:apoio_imobiliario/features/imovel/imovel_form_novoimovel.dart';

class ImoveisView extends StatelessWidget {
  const ImoveisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor:
            Colors.transparent, // Importante para o fundo padrão aparecer
        appBar: AppBar(
          title: const Text('Imóveis'),
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Cadastrar novo imóvel',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.zero, // Remove margem que empurra o ícone
                  minimumSize: const Size(35, 35),
                  fixedSize: const Size(35, 35), // Trava formato quadrado
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Remove área invisível
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroImovel(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: imoveisMock.length,
          itemBuilder: (context, index) {
            final imovel = imoveisMock[index];
            return ImovelCard(imovel: imovel);
          },
        ),
      ),
    );
  }
}
