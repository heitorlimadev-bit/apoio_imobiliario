import 'package:apoio_imobiliario/freatures/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/freatures/cliente/etapa_financialmento.dart';

List<ClienteModel> clientes = [
  // Montagem de pasta
  ClienteModel(
    id: 1,
    nome: 'Maria Silva',
    email: 'maria@email.com',
    telefone: '17999991001',
    capitalProprio: 30000,
    cartaCredito: 200000,
    etapaFinancialmento: EtapaFinancialmento.montagemDePasta,
  ),
  ClienteModel(
    id: 2,
    nome: 'João Santos',
    email: 'joao@email.com',
    telefone: '17999991002',
    capitalProprio: 45000,
    cartaCredito: 250000,
    etapaFinancialmento: EtapaFinancialmento.montagemDePasta,
  ),

  // Análise de crédito
  ClienteModel(
    id: 3,
    nome: 'Ana Oliveira',
    email: 'ana@email.com',
    telefone: '17999991003',
    capitalProprio: 25000,
    cartaCredito: 180000,
    etapaFinancialmento: EtapaFinancialmento.analiseDeCredito,
  ),
  ClienteModel(
    id: 4,
    nome: 'Pedro Costa',
    email: 'pedro@email.com',
    telefone: '17999991004',
    capitalProprio: 40000,
    cartaCredito: 220000,
    etapaFinancialmento: EtapaFinancialmento.analiseDeCredito,
  ),

  // Crédito aprovado
  ClienteModel(
    id: 5,
    nome: 'Lucas Ferreira',
    email: 'lucas@email.com',
    telefone: '17999991005',
    capitalProprio: 50000,
    cartaCredito: 300000,
    etapaFinancialmento: EtapaFinancialmento.creditoAprovado,
  ),
  ClienteModel(
    id: 6,
    nome: 'Beatriz Lima',
    email: 'beatriz@email.com',
    telefone: '17999991006',
    capitalProprio: 35000,
    cartaCredito: 230000,
    etapaFinancialmento: EtapaFinancialmento.creditoAprovado,
  ),

  // Crédito reprovado
  ClienteModel(
    id: 7,
    nome: 'Rafael Almeida',
    email: 'rafael@email.com',
    telefone: '17999991007',
    capitalProprio: 15000,
    cartaCredito: 160000,
    etapaFinancialmento: EtapaFinancialmento.creditoReprovado,
  ),
  ClienteModel(
    id: 8,
    nome: 'Juliana Rocha',
    email: 'juliana@email.com',
    telefone: '17999991008',
    capitalProprio: 20000,
    cartaCredito: 190000,
    etapaFinancialmento: EtapaFinancialmento.creditoReprovado,
  ),

  // Engenharia
  ClienteModel(
    id: 9,
    nome: 'Gabriel Martins',
    email: 'gabriel@email.com',
    telefone: '17999991009',
    capitalProprio: 40000,
    cartaCredito: 240000,
    etapaFinancialmento: EtapaFinancialmento.engenharia,
  ),
  ClienteModel(
    id: 10,
    nome: 'Camila Souza',
    email: 'camila@email.com',
    telefone: '17999991010',
    capitalProprio: 55000,
    cartaCredito: 320000,
    etapaFinancialmento: EtapaFinancialmento.engenharia,
  ),

  // Assinatura de contrato
  ClienteModel(
    id: 11,
    nome: 'Felipe Ribeiro',
    email: 'felipe@email.com',
    telefone: '17999991011',
    capitalProprio: 60000,
    cartaCredito: 350000,
    etapaFinancialmento: EtapaFinancialmento.assinaturaDeContrato,
  ),
  ClienteModel(
    id: 12,
    nome: 'Larissa Mendes',
    email: 'larissa@email.com',
    telefone: '17999991012',
    capitalProprio: 48000,
    cartaCredito: 280000,
    etapaFinancialmento: EtapaFinancialmento.assinaturaDeContrato,
  ),
];