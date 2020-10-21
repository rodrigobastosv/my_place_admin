import 'package:flutter/material.dart';
import 'package:my_place/model/usuario_model.dart';
import 'package:my_place/page/categoria/list_categoria_page.dart';

class HomePage extends StatelessWidget {
  HomePage(this.usuario);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Text('Criar Produto'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ListCategoriaPage(),
                  ),
                );
              },
              child: Container(
                height: 100,
                width: 100,
                child: Text('Categorias'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
