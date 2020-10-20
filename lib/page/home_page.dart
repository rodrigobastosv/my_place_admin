import 'package:flutter/material.dart';
import 'package:my_place/model/usuario_model.dart';

class HomePage extends StatelessWidget {
  HomePage(this.usuario);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
