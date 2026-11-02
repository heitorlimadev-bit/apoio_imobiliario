import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';

class ImovelModel {
  final int id;
  final int clienteId;
  final String descricaoImovel;
  final TipoImovel tipoImovel;
  final String ruaImovel;
  final String bairroImovel;
  final int areaConstruida;
  final int qtDormitorios;
  final int qtBanheiros;
  final int qtGaragens;
  final StatusImovel statusImovel;
  final num valor;
  final String foto;

  ImovelModel({
    required this.id,
    required this.clienteId,
    required this.descricaoImovel,
    required this.tipoImovel,
    required this.ruaImovel,
    required this.bairroImovel,
    required this.areaConstruida,
    required this.qtDormitorios,
    required this.qtBanheiros,
    required this.qtGaragens,
    required this.statusImovel,
    required this.valor,
    required this.foto,
  });
}
