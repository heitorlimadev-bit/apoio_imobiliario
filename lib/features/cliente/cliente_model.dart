import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteModel {
  int id;
  String nome;
  String email;
  String telefone;
  int capitalProprio;
  int cartaCredito;
  EtapaFinanciamento etapaFinanciamento;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.capitalProprio,
    required this.cartaCredito,
    required this.etapaFinanciamento,
  });
}
