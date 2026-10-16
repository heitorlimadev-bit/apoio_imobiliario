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


  final List<ClienteInfo> clientes = [
    ClienteInfo(
      id: 1,
      nome: 'Maria Silva',
      email: 'maria@email.com',
      telefone: '(11) 99999-1111',
      capitalProprio: 80000,
      cartaCredito: 250000,
      etapaFinancialmento: EtapaFinancialmento.simulacao,
    ),
    ClienteInfo(
      id: 2,
      nome: 'João Souza',
      email: 'joao@email.com',
      telefone: '(11) 98888-2222',
      capitalProprio: 120000,
      cartaCredito: 350000,
      etapaFinancialmento: EtapaFinancialmento.aprovacao,
    ),
    ClienteInfo(
      id: 3,
      nome: 'Ana Oliveira',
      email: 'ana@email.com',
      telefone: '(21) 97777-3333',
      capitalProprio: 60000,
      cartaCredito: 200000,
      etapaFinancialmento: EtapaFinancialmento.documentacao,
    ),
    ClienteInfo(
      id: 4,
      nome: 'Pedro Santos',
      email: 'pedro@email.com',
      telefone: '(31) 96666-4444',
      capitalProprio: 150000,
      cartaCredito: 400000,
      etapaFinancialmento: EtapaFinancialmento.concluido,
    ),
    ClienteInfo(
      id: 5,
      nome: 'Carla Mendes',
      email: 'carla@email.com',
      telefone: '(41) 95555-5555',
      capitalProprio: 95000,
      cartaCredito: 300000,
      etapaFinancialmento: EtapaFinancialmento.analise,
    ),
  ];