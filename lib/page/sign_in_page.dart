import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/usuario_model.dart';
import '../widget/logo.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email = "";
  String _senha = "";
  final _formKey = GlobalKey<FormState>();

  final _firebaseAuth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'E-mail',
                ),
                validator: (email) =>
                    email.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (email) => _email = email,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Senha',
                ),
                obscureText: true,
                validator: (senha) =>
                    senha.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (senha) => _senha = senha,
              ),
              SizedBox(height: 16),
              Container(
                width: 150,
                child: RaisedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      final userFireAuth =
                          await _firebaseAuth.signInWithEmailAndPassword(
                        email: _email,
                        password: _senha,
                      );
                      final userFirestore =
                          await _usersRef.doc(userFireAuth.user.uid).get();
                      final user = UsuarioModel.fromJson(userFirestore.data());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HomePage(user),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SignUpPage(),
                    ),
                  ),
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
