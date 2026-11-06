enum TipoImovel { 
  apartamento('Apartamento'),
  casa('Casa'),
  terreno('Terreno'), 
  salaComercial('Sala'), 
  galpao('Galpao');

  const TipoImovel(this.rotulo);
  final String rotulo;
}

enum StatusImovel { 
  disponivel('Disponível'), 
  vendido('Vendido'), 
  alugado('Alugado');

  const StatusImovel (this.rotulo);
  final String rotulo;
}

enum NegociacaoImovel{
  aluguel('Aluguel'),
  venda('Venda'),
  troca('Troca');

  const NegociacaoImovel (this.rotulo);
  final String rotulo;
}