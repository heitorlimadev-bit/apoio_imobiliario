import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ClienteController {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ClienteController({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _corretorId {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw StateError('Faça login para acessar seus clientes.');
    }

    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _clientes =>
      _db.collection('clientes');

  // Observar somente os clientes do corretor autenticado.
  Stream<List<ClienteModel>> observarClientes() {
    final uid = _corretorId;

    return _clientes
        .where('corretorId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final clientes = snapshot.docs
          .map((doc) => ClienteModel.fromDocument(doc))
          .toList();

      clientes.sort(
        (a, b) => a.nome.toLowerCase().compareTo(
              b.nome.toLowerCase(),
            ),
      );

      return clientes;
    });
  }

  // Cadastrar cliente no Firestore.
  Future<ClienteModel> adicionar(ClienteModel cliente) async {
    final uid = _corretorId;

    final doc = await _clientes.add({
      ...cliente.toMap(corretorId: uid),
      'criadoEm': FieldValue.serverTimestamp(),
    });

    final salvo = await doc.get();

    return ClienteModel.fromDocument(salvo);
  }

  // Atualizar dados do cliente.
  Future<void> atualizar(ClienteModel cliente) async {
    final uid = _corretorId;

    if (cliente.id.isEmpty) {
      throw StateError('ID do cliente inválido.');
    }

    await _clientes.doc(cliente.id).update(
          cliente.toMap(corretorId: uid),
        );
  }

  // Alterar etapa do financiamento.
  Future<void> alterarEtapa(
    ClienteModel cliente,
    EtapaFinanciamento etapa,
  ) async {
    final uid = _corretorId;

    await _clientes.doc(cliente.id).update({
      'etapaFinanciamento': etapa.name,
      'corretorId': uid,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Excluir cliente.
  Future<void> excluir(String id) async {
    final uid = _corretorId;

    final ref = _clientes.doc(id);
    final doc = await ref.get();

    if (doc.data()?['corretorId'] != uid) {
      throw StateError(
        'Você não tem permissão para excluir este cliente.',
      );
    }

    await ref.delete();
  }
}