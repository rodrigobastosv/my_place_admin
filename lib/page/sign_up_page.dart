import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/logo.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _nome = "";
  String _email = "";
  String _senha = "";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _firebaseAuth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('usuarios');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Logo(),
                        const SizedBox(height: 24),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(
                              Icons.person,
                              size: 24,
                            ),
                          ),
                          validator: (nome) =>
                              nome.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: (nome) => _nome = nome,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(
                              Icons.mail,
                              size: 24,
                            ),
                          ),
                          validator: (email) =>
                              email.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: (email) => _email = email,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 24,
                            ),
                          ),
                          obscureText: true,
                          validator: (senha) =>
                              senha.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: (senha) => _senha = senha,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Repita a senha',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 24,
                            ),
                          ),
                          obscureText: true,
                          validator: (passwordConfirm) =>
                              passwordConfirm.isEmpty
                                  ? 'Campo Obrigatório'
                                  : null,
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  form.save();
                                  final userCredential = await _firebaseAuth
                                      .createUserWithEmailAndPassword(
                                    email: _email,
                                    password: _senha,
                                  );
                                  await _userRef
                                      .doc(userCredential.user.uid)
                                      .set({
                                    'nome': _nome,
                                    'email': _email,
                                  });
                                  Navigator.of(context).pop();
                                } on Exception catch (e) {
                                  if (e is FirebaseAuthException) {
                                    if (e.code == 'email-already-in-use') {
                                      print('Email indisponivel!');
                                    } else if (e.code == 'weak-password') {
                                      print('Senha muito fraca!');
                                    }
                                  } else {
                                    print('Erro ao criar usuário');
                                    form.reset();
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: OutlineButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Voltar',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
