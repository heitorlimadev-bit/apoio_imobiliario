import 'etapa_financialmento.dart';

class ClienteInfo {
  int id;
  String nome;
  String email;
  String telefone;
  int capitalProprio;
  int cartaCredito;
  EtapaFinancialmento etapaFinancialmento;
  
  ClienteInfo({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.capitalProprio,
    required this.cartaCredito,
    required this.etapaFinancialmento,
  });
}