import 'imovel_tipos_status.dart';

class ImovelInfoModel {
  String id;
  String nome;
  String endereco;
  Tipo tipo;
  Status status;
  int valor;
  String descricao;

  ImovelInfoModel({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.tipo,
    required this.status,
    required this.valor,
    required this.descricao,
  });
}