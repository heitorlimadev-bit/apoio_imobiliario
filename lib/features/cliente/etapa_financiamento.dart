enum EtapaFinanciamento {
  montagemDePasta('Montagem de Pasta'),
  analiseDeCredito('Análise de crédito'),
  creditoAprovado('Crédito aprovado'),
  creditoReprovado('Crédito reprovado'),
  engenharia('Análise de engenharia'),
  assinaturaDeContrato('Assinatura de contrato');

  const EtapaFinanciamento(this.rotulo);
  final String rotulo;
}
