import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _nome = "";
  String _email = "";
  String _senha = "";
  final _formKey = GlobalKey<FormState>();

  final _firebaseAuth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Nome',
                ),
                validator: (nome) => nome.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (nome) => _nome = nome,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'E-mail',
                ),
                validator: (email) =>
                    email.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (email) => _email = email,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Senha',
                ),
                obscureText: true,
                validator: (senha) =>
                    senha.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (senha) => _senha = senha,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Confirmar Senha',
                ),
                obscureText: true,
                validator: (passwordConfirm) =>
                    passwordConfirm.isEmpty ? 'Campo Obrigatório' : null,
              ),
              SizedBox(height: 12),
              RaisedButton(
                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final userCredential =
                        await _firebaseAuth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _senha,
                    );
                    await _userRef.doc(userCredential.user.uid).set({
                      'nome': _nome,
                      'email': _email,
                    });
                  }
                },
                child: Text('Cadastrar Usuário'),
              ),
              SizedBox(height: 12),
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
