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
  disponivel('a'), 
  vendido('a'), 
  alugado('Alugado');

  const StatusImovel (this.rotulo);
  final String rotulo;
}
