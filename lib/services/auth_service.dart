import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get usuarioAtual => _auth.currentUser;

  // Caminho dos dados do corretor.
  DocumentReference<Map<String, dynamic>> _referenciaCorretor(
    String uid,
  ) {
    return _firestore.collection('corretores').doc(uid);
  }

  // CADASTRAR CORRETOR
  Future<UserCredential> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final usuario = credencial.user!;

    try {
      await usuario.updateDisplayName(nome.trim());

      await _referenciaCorretor(usuario.uid).set({
        'uid': usuario.uid,
        'nome': nome.trim(),
        'email': email.trim(),
        'dataCadastro': FieldValue.serverTimestamp(),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });

      return credencial;
    } catch (erro) {
      // Evita deixar uma conta parcialmente cadastrada.
      await usuario.delete();
      rethrow;
    }
  }

  // LOGIN
  Future<UserCredential> login({
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    // Garante que o perfil do corretor exista no Firestore.
    await garantirPerfilCorretor();

    return credencial;
  }

  // GARANTIR PERFIL DO CORRETOR
  Future<void> garantirPerfilCorretor() async {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum corretor autenticado.');
    }

    final referencia = _referenciaCorretor(usuario.uid);
    final documento = await referencia.get();

    if (!documento.exists) {
      await referencia.set({
        'uid': usuario.uid,
        'nome': usuario.displayName ?? 'Corretor',
        'email': usuario.email ?? '',
        'dataCadastro': FieldValue.serverTimestamp(),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });
    } else {
      await referencia.set({
        'uid': usuario.uid,
        'email': usuario.email ?? '',
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
  // ATUALIZAR DADOS DO CORRETOR
  Future<void> atualizarDados({
    required String nome,
  }) async {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    await usuario.updateDisplayName(nome.trim());

    await _referenciaCorretor(usuario.uid).set({
      'nome': nome.trim(),
      'ultimaAtualizacao': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // SAIR DA CONTA
  Future<void> logout() async {
    await _auth.signOut();
  }
}
