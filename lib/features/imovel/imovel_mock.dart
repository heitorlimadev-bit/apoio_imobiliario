import 'package:apoio_imobiliario/features/imovel/imovel_model.dart';
import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';

final List<ImovelModel> imoveisMock = [
  ImovelModel(
    id: 1,
    clienteId: 1,
    descricaoImovel: 'Casa de Locação em São José do Rio Preto-SP',
    tipoImovel: TipoImovel.casa,
    ruaImovel: 'Rua Saulo de Oliveira Pereira',
    bairroImovel: 'Parque Residencial da Fraternidade 2',
    areaConstruida: 48,
    qtDormitorios: 2,
    qtBanheiros: 1,
    qtGaragens: 2,
    statusImovel: StatusImovel.disponivel,
    valor: 950000.00,
    foto: 'assets/images/Casa2_1.jpg', // Deixando vazio para mostrar o ícone de fallback
  ),
  ImovelModel(
    id: 2,
    clienteId: 2,
    descricaoImovel: 'Apartamento moderno com sacada',
    tipoImovel: TipoImovel.apartamento,
    ruaImovel: 'Av. Alberto Andaló',
    bairroImovel: 'Centro',
    areaConstruida: 65,
    qtDormitorios: 2,
    qtBanheiros: 2,
    qtGaragens: 1,
    statusImovel: StatusImovel.disponivel,
    valor: 1350000.0,
    foto: 'assets/images/Casa1_1.jpg',
  ),
];
