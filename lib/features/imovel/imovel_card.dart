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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      color: const Color.fromARGB(40, 123, 238, 78), // Fundo do card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área da Foto com Ícone de Favorito

          // Área da Foto com Ícone de Favorito
          Stack(
            children: [
              _buildImagem(), // O antigo Container cinza foi substituído por esta linha
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descrição
                Text(
                  imovel.descricaoImovel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cores.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Rua e Bairro
                Text(
                  imovel.ruaImovel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cores.onSurface,
                  ),
                ),
                Text(
                  imovel.bairroImovel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cores.onSecondary,
                  ),
                ),
                const SizedBox(height: 12),
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cores.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Botões Contatar e WhatsApp
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cores.primary,
                          foregroundColor: cores.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {}, //vazio por enquanto
                        child: const Text('WhatsApp'),
                      ),
                    ),

                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cores.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {}, //vazio por enquanto
                      child: Icon(Icons.phone, color: cores.primary),
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
    return Row(
      children: [
        Icon(icon, size: 16, color: cores.onSecondary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: cores.onSurface)),
      ],
    );
  }

  Widget _buildImagem() {
    // 1. Verifica se a string veio completamente vazia
    if (imovel.foto.isEmpty) {
      return _buildFundoSemFoto();
    }

    // 2. Tenta carregar a foto. Se der erro (arquivo não encontrado), exibe o fundo cinza.
    return Image.asset(
      imovel.foto,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFundoSemFoto();
      },
    );
  }

  // Método que desenha o fundo cinza com o ícone de imagem ausente
  Widget _buildFundoSemFoto() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[800],
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}
