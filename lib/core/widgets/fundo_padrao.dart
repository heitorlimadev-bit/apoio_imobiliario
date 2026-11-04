import 'package:flutter/material.dart';

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
        //gradient: LinearGradient(
        // begin: Alignment.topCenter,
        // end: Alignment.bottomCenter,
        //colors: [cores.primary, cores.secondary],
        // stops: const [0.0, 0.4],
        //),
        image: const DecorationImage(
          image: AssetImage('assets/images/DoodlePreto1.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.2,
        ),
      ),
      child: conteudo,
    );
  }
}
