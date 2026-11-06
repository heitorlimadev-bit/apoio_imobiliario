import 'package:apoio_imobiliario/features/imovel/imovel_model.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';

final List<ImovelModel> imoveisMock = [
  ImovelModel(
    id: 1,
    tipoImovel: TipoImovel.casa,
    descricaoImovel: 'Casa térrea para Locação',
    cidadeImovel: 'São José do Rio Preto - SP',
    ruaImovel: 'Rua Saulo de Oliveira Pereira',
    numeroImovel: 20,
    numeroApImovel: 5,
    bairroImovel: 'Parque Residencial da Fraternidade 2',
    areaConstruida: 48,
    qtDormitorios: 2,
    qtBanheiros: 1,
    qtGaragens: 2,
    valor: 950000.00,
    statusImovel: StatusImovel.disponivel,
    negociacaoImovel: NegociacaoImovel.venda,
    foto: 'assets/images/Casa2_1.jpg', // Deixando vazio para mostrar o ícone de fallback
  ),
  ImovelModel(
    id: 2,
    tipoImovel: TipoImovel.apartamento,
    descricaoImovel: 'Apartamento moderno com sacada',
    cidadeImovel: 'São José do Rio Preto - SP',
    ruaImovel: 'Av. Alberto Andaló',
    numeroImovel: 50,
    numeroApImovel: 5,
    bairroImovel: 'Centro',
    areaConstruida: 65,
    qtDormitorios: 2,
    qtBanheiros: 2,
    qtGaragens: 1,
    valor: 1350000.0,
    statusImovel: StatusImovel.disponivel,
    negociacaoImovel: NegociacaoImovel.aluguel,
    foto: 'assets/images/Casa1_1.jpg',
  ),
];
