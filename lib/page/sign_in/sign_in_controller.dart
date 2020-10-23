import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_place/exceptions/email_invalido_exception.dart';
import 'package:my_place/exceptions/senha_errada_exception.dart';
import 'package:my_place/exceptions/usuario_nao_encontrado_exception.dart';
import 'package:my_place/model/usuario_model.dart';

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
      final user = UsuarioModel.fromJson(userFirestore.data());
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
