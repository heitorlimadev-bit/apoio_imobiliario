import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';

class ImovelModel {
  final int id;
  final String nomeImovel;
  final String endereco;
  final TipoImovel tipoImovel;
  final StatusImovel statusImovel;
  final int valor;
  final String descricao;

  ImovelModel({
    required this.id,
    required this.nomeImovel,
    required this.endereco,
    required this.tipoImovel,
    required this.statusImovel,
    required this.valor,
    required this.descricao,
  });
}
