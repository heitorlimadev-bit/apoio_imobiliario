enum EtapaFinanciamento {
  montagemDePasta('Montagem de Pasta'),
  analiseDeCredito('Análise de crédito'),
  creditoAprovado('Crédito aprovado'),
  engenharia('Análise de engenharia'),
  assinaturaDeContrato('Assinatura de contrato'),
  creditoReprovado('Crédito reprovado')
  ;

  EtapaFinanciamento? get seguinte => switch (this) {
    montagemDePasta => analiseDeCredito,
    analiseDeCredito => creditoAprovado,
    creditoAprovado => engenharia,
    engenharia => assinaturaDeContrato,
    assinaturaDeContrato => null,
    creditoReprovado => montagemDePasta,
  };

  EtapaFinanciamento? get anterior => switch (this) {
    montagemDePasta => null,
    analiseDeCredito => montagemDePasta,
    creditoAprovado => analiseDeCredito,
    engenharia => creditoAprovado,
    assinaturaDeContrato => engenharia,
    creditoReprovado => analiseDeCredito,
  };

  const EtapaFinanciamento(this.rotulo);
  final String rotulo;
}
