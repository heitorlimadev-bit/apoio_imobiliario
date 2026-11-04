
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CADASTRAR NOVO CORRETOR
  Future<UserCredential> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    // Cria o usuário no Firebase Authentication
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final usuario = credencial.user!;

    // Salva os dados do corretor no Firestore
    await _firestore.collection('corretores').doc(usuario.uid).set({
      'uid': usuario.uid,
      'nome': nome.trim(),
      'email': email.trim(),
      'dataCadastro': FieldValue.serverTimestamp(),
    });

    return credencial;
  }

  // FAZER LOGIN
  Future<UserCredential> login({
    required String email,
    required String senha,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  // SAIR DA CONTA
  Future<void> logout() async {
    await _auth.signOut();
  }

  // CONSULTAR USUÁRIO ATUAL
  User? get usuarioAtual => _auth.currentUser;
}
