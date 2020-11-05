import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_place_models/models/models.dart';

import '../../exceptions/exceptions.dart';

class SignInController {
  String _email = "";
  String _senha = "";
  bool _isLoading = false;

  final _firebaseAuth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection('usuarios');

  void setEmail(String email) => _email = email;

  void setSenha(String senha) => _senha = senha;

  void setIsLoading(bool isLoading) => _isLoading = isLoading;

  bool get isLoading => _isLoading;

  Future<UsuarioModel> fazLogin() async {
    try {
      final userFireAuth = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email,
        password: _senha,
      );
      final userFirestore = await _usersRef.doc(userFireAuth.user.uid).get();
      final user = UsuarioModel.fromJson(userFirestore.id, userFirestore.data());
      if (user.tipo != 'ADMIN') {
        throw AdminInvalidoException();
      }
      return user;
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw UsuarioNaoEncontradoException();
        } else if (e.code == 'wrong-password') {
          throw SenhaErradaException();
        } else if (e.code == 'invalid-email') {
          throw EmailInvalidoException();
        }
      } else {
        rethrow;
      }
    }
    return null;
  }
}
