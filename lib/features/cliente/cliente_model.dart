import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteModel {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final int capitalProprio;
  final int cartaCredito;
  final EtapaFinanciamento etapaFinanciamento;

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
