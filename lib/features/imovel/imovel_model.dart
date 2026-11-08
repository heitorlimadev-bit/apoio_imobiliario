
import 'package:cloud_firestore/cloud_firestore.dart';
import 'imovel_tipos_status.dart';

class ImovelModel {
  final String id;
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

  Map<String, dynamic> toMap() {
    return {
      'tipoImovel': tipoImovel.name,
      'descricaoImovel': descricaoImovel,
      'cidadeImovel': cidadeImovel,
      'ruaImovel': ruaImovel,
      'numeroImovel': numeroImovel,
      'numeroApImovel': numeroApImovel,
      'bairroImovel': bairroImovel,
      'areaConstruida': areaConstruida,
      'qtDormitorios': qtDormitorios,
      'qtBanheiros': qtBanheiros,
      'qtGaragens': qtGaragens,
      'valor': valor,
      'statusImovel': statusImovel.name,
      'negociacaoImovel': negociacaoImovel.name,
      'foto': foto,
    };
  }

  factory ImovelModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final dados = doc.data()!;

    return ImovelModel(
      id: doc.id,
      tipoImovel: TipoImovel.values.firstWhere(
        (e) => e.name == dados['tipoImovel'],
        orElse: () => TipoImovel.casa,
      ),
      descricaoImovel: dados['descricaoImovel'] ?? '',
      cidadeImovel: dados['cidadeImovel'] ?? '',
      ruaImovel: dados['ruaImovel'] ?? '',
      numeroImovel: (dados['numeroImovel'] as num?)?.toInt() ?? 0,
      numeroApImovel: (dados['numeroApImovel'] as num?)?.toInt() ?? 0,
      bairroImovel: dados['bairroImovel'] ?? '',
      areaConstruida: (dados['areaConstruida'] as num?)?.toInt() ?? 0,
      qtDormitorios: (dados['qtDormitorios'] as num?)?.toInt() ?? 0,
      qtBanheiros: (dados['qtBanheiros'] as num?)?.toInt() ?? 0,
      qtGaragens: (dados['qtGaragens'] as num?)?.toInt() ?? 0,
      valor: (dados['valor'] as num?) ?? 0,
      statusImovel: StatusImovel.values.firstWhere(
        (e) => e.name == dados['statusImovel'],
        orElse: () => StatusImovel.disponivel,
      ),
      negociacaoImovel: NegociacaoImovel.values.firstWhere(
        (e) => e.name == dados['negociacaoImovel'],
        orElse: () => NegociacaoImovel.venda,
      ),
      foto: dados['foto'] ?? '',
    );
  }
}
