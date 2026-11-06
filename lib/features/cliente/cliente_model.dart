import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteModel {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final int capitalProprio;
  final int cartaCredito;
  final EtapaFinanciamento etapaFinanciamento;

  const ClienteModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.capitalProprio,
    required this.cartaCredito,
    required this.etapaFinanciamento,
  });

  ClienteModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    int? capitalProprio,
    int? cartaCredito,
    EtapaFinanciamento? etapaFinanciamento,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      capitalProprio: capitalProprio ?? this.capitalProprio,
      cartaCredito: cartaCredito ?? this.cartaCredito,
      etapaFinanciamento:
          etapaFinanciamento ?? this.etapaFinanciamento,
    );
  }

  // Converter os dados para salvar no Firestore.
  Map<String, dynamic> toMap({
    required String corretorId,
  }) {
    return {
      'corretorId': corretorId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'capitalProprio': capitalProprio,
      'cartaCredito': cartaCredito,
      'etapaFinanciamento': etapaFinanciamento.name,
      'atualizadoEm': FieldValue.serverTimestamp(),
    };
  }

  // Recuperar os dados do Firestore.
  factory ClienteModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    final etapaNome =
        data['etapaFinanciamento'] as String?;

    final etapa = EtapaFinanciamento.values.firstWhere(
      (e) => e.name == etapaNome,
      orElse: () => EtapaFinanciamento.montagemDePasta,
    );

    return ClienteModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      email: data['email'] as String? ?? '',
      telefone: data['telefone'] as String? ?? '',
      capitalProprio:
          (data['capitalProprio'] as num?)?.toInt() ?? 0,
      cartaCredito:
          (data['cartaCredito'] as num?)?.toInt() ?? 0,
      etapaFinanciamento: etapa,
    );
  }
}