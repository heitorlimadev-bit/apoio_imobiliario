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


List<ClienteInfo> clientes = [
  // Montagem de pasta
  ClienteInfo(
    id: 1,
    nome: 'Maria Silva',
    email: 'maria@email.com',
    telefone: '17999991001',
    capitalProprio: 30000,
    cartaCredito: 200000,
    etapaFinancialmento: EtapaFinancialmento.montagemDePasta,
  ),
  ClienteInfo(
    id: 2,
    nome: 'João Santos',
    email: 'joao@email.com',
    telefone: '17999991002',
    capitalProprio: 45000,
    cartaCredito: 250000,
    etapaFinancialmento: EtapaFinancialmento.montagemDePasta,
  ),

  // Análise de crédito
  ClienteInfo(
    id: 3,
    nome: 'Ana Oliveira',
    email: 'ana@email.com',
    telefone: '17999991003',
    capitalProprio: 25000,
    cartaCredito: 180000,
    etapaFinancialmento: EtapaFinancialmento.analiseDeCredito,
  ),
  ClienteInfo(
    id: 4,
    nome: 'Pedro Costa',
    email: 'pedro@email.com',
    telefone: '17999991004',
    capitalProprio: 40000,
    cartaCredito: 220000,
    etapaFinancialmento: EtapaFinancialmento.analiseDeCredito,
  ),

  // Crédito aprovado
  ClienteInfo(
    id: 5,
    nome: 'Lucas Ferreira',
    email: 'lucas@email.com',
    telefone: '17999991005',
    capitalProprio: 50000,
    cartaCredito: 300000,
    etapaFinancialmento: EtapaFinancialmento.creditoAprovado,
  ),
  ClienteInfo(
    id: 6,
    nome: 'Beatriz Lima',
    email: 'beatriz@email.com',
    telefone: '17999991006',
    capitalProprio: 35000,
    cartaCredito: 230000,
    etapaFinancialmento: EtapaFinancialmento.creditoAprovado,
  ),

  // Crédito reprovado
  ClienteInfo(
    id: 7,
    nome: 'Rafael Almeida',
    email: 'rafael@email.com',
    telefone: '17999991007',
    capitalProprio: 15000,
    cartaCredito: 160000,
    etapaFinancialmento: EtapaFinancialmento.creditoReprovado,
  ),
  ClienteInfo(
    id: 8,
    nome: 'Juliana Rocha',
    email: 'juliana@email.com',
    telefone: '17999991008',
    capitalProprio: 20000,
    cartaCredito: 190000,
    etapaFinancialmento: EtapaFinancialmento.creditoReprovado,
  ),

  // Engenharia
  ClienteInfo(
    id: 9,
    nome: 'Gabriel Martins',
    email: 'gabriel@email.com',
    telefone: '17999991009',
    capitalProprio: 40000,
    cartaCredito: 240000,
    etapaFinancialmento: EtapaFinancialmento.engenharia,
  ),
  ClienteInfo(
    id: 10,
    nome: 'Camila Souza',
    email: 'camila@email.com',
    telefone: '17999991010',
    capitalProprio: 55000,
    cartaCredito: 320000,
    etapaFinancialmento: EtapaFinancialmento.engenharia,
  ),

  // Assinatura de contrato
  ClienteInfo(
    id: 11,
    nome: 'Felipe Ribeiro',
    email: 'felipe@email.com',
    telefone: '17999991011',
    capitalProprio: 60000,
    cartaCredito: 350000,
    etapaFinancialmento: EtapaFinancialmento.assinaturaDeContrato,
  ),
  ClienteInfo(
    id: 12,
    nome: 'Larissa Mendes',
    email: 'larissa@email.com',
    telefone: '17999991012',
    capitalProprio: 48000,
    cartaCredito: 280000,
    etapaFinancialmento: EtapaFinancialmento.assinaturaDeContrato,
  ),
];
