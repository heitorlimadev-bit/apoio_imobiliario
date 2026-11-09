import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_model.dart';

class ImovelCard extends StatelessWidget {
  final ImovelModel imovel;
  final VoidCallback onEditar;

  const ImovelCard({
    super.key,
    required this.imovel,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cores = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias, // cor, borda e raio vêm do tema
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área da Foto
          Stack(
            children: [
              _buildImagem(cores),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton.filled(
                  onPressed: onEditar,
                  tooltip: 'Editar imóvel',
                  icon: const Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tipo
                    Text(
                      imovel.tipoImovel.rotulo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cores.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),

                    // Status
                    Text(
                      imovel.statusImovel.rotulo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cores.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),

                    //interesse em negociacao
                    Text(
                      imovel.negociacaoImovel.rotulo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cores.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Descrição
                Text(
                  imovel.descricaoImovel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cores.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 10),

                // Valor
                Text(
                  formatarValor(imovel.valor),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cores.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagem(ColorScheme cores) {
    final foto = imovel.foto.trim();

    if (foto.isEmpty) {
      return _buildFundoSemFoto(cores);
    }

    // Fotos da galeria interna são salvas como caminho de asset
    // (assets/images/...); só URLs http(s) vêm da internet/Storage.
    final isNetwork =
        foto.startsWith('http://') || foto.startsWith('https://');

    if (!isNetwork) {
      return Image.asset(
        foto,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFundoSemFoto(cores),
      );
    }

    return Image.network(
      foto,
      height: 190,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _buildFundoSemFoto(cores),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 190,
          width: double.infinity,
          color: cores.surfaceContainerHigh,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
    );
  }

  //metodo para formatar os milhares do valor do card
  String formatarValor(num valor) {
    final valorInteiro = valor.toInt().toString();
    // Insere o ponto a cada 3 dígitos da direita para a esquerda
    final valorComPontos = valorInteiro.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'R\$ $valorComPontos';
  }

  // Método que desenha o fundo cinza com o ícone de imagem ausente
  Widget _buildFundoSemFoto(ColorScheme cores) {
    return Container(
      height: 190,
      width: double.infinity,
      color: cores.surfaceContainerHigh,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 44,
        color: cores.onSurfaceVariant,
      ),
    );
  }
}