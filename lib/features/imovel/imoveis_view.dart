import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/core/widgets/fundo_padrao.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_card.dart'; // Ajuste o caminho
import 'package:apoio_imobiliario/features/imovel/imovel_mock.dart'; // Seu mock de imóveis

class ImoveisView extends StatelessWidget {
  const ImoveisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Fundopadrao(
      conteudo: Scaffold(
        backgroundColor:
            Colors.transparent, // Importante para o fundo padrão aparecer
        appBar: AppBar(
          title: const Text('Imóveis Disponíveis'),
          backgroundColor: Colors.transparent,
        ),
        body: ListView.builder(
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
