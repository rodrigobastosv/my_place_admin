import 'package:flutter/material.dart';
import 'package:my_place/exceptions/exceptions.dart';
import 'package:my_place/widget/mp_loading.dart';

import '../../widget/mp_logo.dart';
import '../home/home_page.dart';
import '../sign_up/sign_up_page.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: _controller.isLoading
            ? Center(
                child: MPLoading(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MPLogo(),
                        const SizedBox(height: 24),
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
                          onSaved: _controller.setEmail,
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
                          onSaved: _controller.setSenha,
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                setState(() {
                                  _controller.setIsLoading(true);
                                });
                                form.save();
                                try {
                                  final user = await _controller.fazLogin();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => HomePage(user),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } on UsuarioNaoEncontradoException {} on SenhaErradaException {} on EmailInvalidoException {} on Exception {} finally {
                                  setState(() {
                                    _controller.setIsLoading(false);
                                  });
                                }
                              }
                            },
                            child: Text('Entrar'),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: OutlineButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SignUpPage(),
                              ),
                            ),
                            child: Text('Cadastrar'),
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
