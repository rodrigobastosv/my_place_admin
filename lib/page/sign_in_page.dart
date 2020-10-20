import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              RaisedButton(
                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final user = await _firebaseAuth.signInWithEmailAndPassword(
                      email: _email,
                      password: _senha,
                    );
                    print(user);
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 12),
              RaisedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SignUpPage(),),
                ),
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
