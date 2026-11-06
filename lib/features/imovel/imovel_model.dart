import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';

class ImovelModel {
  final int id;
  final TipoImovel tipoImovel;  
  final String descricaoImovel;
  final String cidadeImovel;
  final String ruaImovel;
  final int numeroImovel;
  final int numeroApImovel;
  final String bairroImovel;
  final int areaConstruida;
  final int qtDormitorios;
  final int qtBanheiros;
  final int qtGaragens;  
  final num valor;
  final StatusImovel statusImovel;
  final NegociacaoImovel negociacaoImovel;
  final String foto;

  ImovelModel({
    required this.id,
    required this.tipoImovel,
    required this.descricaoImovel,
    required this.cidadeImovel,
    required this.ruaImovel,
    required this.numeroImovel,
    required this.numeroApImovel,
    required this.bairroImovel,
    required this.areaConstruida,
    required this.qtDormitorios,
    required this.qtBanheiros,
    required this.qtGaragens,
    required this.valor,
    required this.statusImovel,
    required this.negociacaoImovel,    
    required this.foto,
  });
}
