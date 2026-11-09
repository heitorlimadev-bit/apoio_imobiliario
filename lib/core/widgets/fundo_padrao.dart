import 'package:flutter/material.dart';

/// Fundo padrão de todas as telas: cor de superfície do tema com a textura
/// de doodles por cima. Use com um Scaffold de fundo transparente.
class Fundopadrao extends StatelessWidget {
  final Widget conteudo;
  const Fundopadrao({super.key, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: cores.surface,
        image: DecorationImage(
          image: const AssetImage('assets/images/DoodlePreto1.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.1, // textura discreta
          // Pinta os desenhos (originalmente pretos) com o verde do tema.
          colorFilter: ColorFilter.mode(cores.primary, BlendMode.srcIn),
        ),
      ),
      child: conteudo,
    );
  }
}
