import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'imovel_model.dart';

class ImovelController {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  ImovelController({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  String get _corretorId {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw StateError('Faça login para acessar os imóveis.');
    }

    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _imoveis =>
      _db.collection('imoveis');

  // Lista somente os imóveis do corretor autenticado.
  Stream<List<ImovelModel>> observarImoveis() {
    final uid = _auth.currentUser?.uid;

    // Devolve o erro pelo próprio stream (em vez de lançar exceção
    // síncrona no initState da tela), para o StreamBuilder exibi-lo.
    if (uid == null) {
      return Stream.error(StateError('Faça login para acessar os imóveis.'));
    }

    return _imoveis
        .where('corretorId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final lista = snapshot.docs
          .map((doc) => ImovelModel.fromDocument(doc))
          .toList();

      lista.sort(
        (a, b) => a.descricaoImovel.toLowerCase().compareTo(
              b.descricaoImovel.toLowerCase(),
            ),
      );

      return lista;
    });
  }

  // Envia a imagem para o Firebase Storage (opcional, se usar arquivo).
  Future<String> _enviarImagem(
    XFile imagem,
    String imovelId,
  ) async {
    final uid = _corretorId;
    final bytes = await imagem.readAsBytes();

    final extensao = imagem.name.contains('.')
        ? imagem.name.split('.').last.toLowerCase()
        : 'jpg';

    final referencia = _storage.ref(
      'imoveis/$uid/$imovelId/foto.$extensao',
    );

    await referencia.putData(
      bytes,
      SettableMetadata(
        contentType: imagem.mimeType ?? 'image/jpeg',
      ),
    );

    return referencia.getDownloadURL();
  }

  // Cadastrar imóvel.
  // Se [imagem] for passada, faz upload. Caso contrário usa imovel.foto
  // (caminho de asset da galeria interna ou URL já existente).
  Future<void> adicionar(
    ImovelModel imovel, {
    XFile? imagem,
  }) async {
    final uid = _corretorId;
    final documento = _imoveis.doc();

    String fotoUrl = imovel.foto;

    if (imagem != null) {
      fotoUrl = await _enviarImagem(imagem, documento.id);
    }

    await documento.set({
      ...imovel.toMap(),
      'corretorId': uid,
      'foto': fotoUrl,
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Editar imóvel.
  Future<void> atualizar(
    ImovelModel imovel, {
    XFile? imagem,
  }) async {
    final uid = _corretorId;

    if (imovel.id.isEmpty) {
      throw StateError('ID do imóvel inválido.');
    }

    final documento = _imoveis.doc(imovel.id);
    final existente = await documento.get();

    if (!existente.exists ||
        existente.data()?['corretorId'] != uid) {
      throw StateError(
        'Você não tem permissão para editar este imóvel.',
      );
    }

    String fotoUrl = imovel.foto;

    if (imagem != null) {
      fotoUrl = await _enviarImagem(imagem, imovel.id);
    }

    await documento.update({
      ...imovel.toMap(),
      'corretorId': uid,
      'foto': fotoUrl,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Excluir imóvel.
  Future<void> excluir(String imovelId) async {
    final uid = _corretorId;
    final documento = _imoveis.doc(imovelId);
    final existente = await documento.get();

    if (!existente.exists || existente.data()?['corretorId'] != uid) {
      throw StateError('Você não tem permissão para excluir este imóvel.');
    }

    await documento.delete();
  }
}