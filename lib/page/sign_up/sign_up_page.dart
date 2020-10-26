import 'package:flutter/material.dart';
import 'package:my_place/exceptions/exceptions.dart';
import 'package:my_place/page/sign_up/sign_up_controller.dart';
import 'package:my_place/widget/mp_loading.dart';

import '../../widget/mp_logo.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignUpController();

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
                            labelText: 'Nome',
                            prefixIcon: Icon(
                              Icons.person,
                              size: 24,
                            ),
                          ),
                          validator: (nome) =>
                              nome.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: _controller.setNome,
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
                          onChanged: _controller.setSenha,
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
                          validator: _controller.validaConfirmacaoSenha,
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
                                    _controller.setIsLoading(true);
                                  });
                                  form.save();
                                  await _controller.criaUsuario();
                                  Navigator.of(context).pop();
                                } on EmailIndisponivelException {} on SenhaFracaException {} on Exception {} finally {
                                  setState(() {
                                    _controller.setIsLoading(false);
                                  });
                                }
                              }
                            },
                            child: Text('Confirmar'),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: OutlineButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Voltar'),
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
