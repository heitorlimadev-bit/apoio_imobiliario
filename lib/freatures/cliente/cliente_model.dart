import 'package:apoio_imobiliario/freatures/cliente/etapa_financialmento.dart';

class ClienteModel {
  int id;
  String nome;
  String email;
  String telefone;
  int capitalProprio;
  int cartaCredito;
  EtapaFinancialmento etapaFinancialmento;
  
  ClienteModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.capitalProprio,
    required this.cartaCredito,
    required this.etapaFinancialmento,
  });
}
