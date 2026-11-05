import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_model.dart'; // Ajuste o caminho

class ImovelCard extends StatelessWidget {
  final ImovelModel imovel;

  const ImovelCard({super.key, required this.imovel});

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
          // Área da Foto com Ícone de Favorito

          // Área da Foto com Ícone de Favorito
          Stack(
            children: [
              _buildImagem(cores), // O antigo Container cinza foi substituído por esta linha
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descrição
                Text(
                  imovel.descricaoImovel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cores.onSurfaceVariant,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Rua e Bairro
                Text(
                  imovel.ruaImovel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cores.onSurface,
                  ),
                ),
                Text(
                  imovel.bairroImovel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cores.onSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                // Ícones de características
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconRow(
                      Icons.aspect_ratio,
                      '${imovel.areaConstruida}m²',
                      cores,
                    ),
                    _buildIconRow(Icons.bed, '${imovel.qtDormitorios}', cores),
                    _buildIconRow(Icons.shower, '${imovel.qtBanheiros}', cores),
                    _buildIconRow(
                      Icons.directions_car,
                      '${imovel.qtGaragens}',
                      cores,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Preço
                Text(
                  'R\$ ${imovel.valor.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cores.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Botões Contatar e WhatsApp
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {}, //vazio por enquanto
                        child: const Text('WhatsApp'),
                      ),
                    ),

                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(48, 48),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {}, //vazio por enquanto
                      child: Icon(Icons.phone, color: cores.primary, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os ícones pequenos (área, quartos, etc)
  Widget _buildIconRow(IconData icon, String text, ColorScheme cores) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cores.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cores.onSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: cores.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagem(ColorScheme cores) {
    // 1. Verifica se a string veio completamente vazia
    if (imovel.foto.isEmpty) {
      return _buildFundoSemFoto(cores);
    }

    // 2. Tenta carregar a foto. Se der erro (arquivo não encontrado), exibe o fundo cinza.
    return Image.asset(
      imovel.foto,
      height: 190,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFundoSemFoto(cores);
      },
    );
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
