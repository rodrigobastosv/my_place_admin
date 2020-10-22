import 'package:flutter/material.dart';

import '../model/usuario_model.dart';
import 'categoria/lista_categorias_page.dart';
import 'produto/lista_produtos_page.dart';

class HomePage extends StatelessWidget {
  HomePage(this.usuario);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ListaProdutosPage(),
                  ),
                );
              },
              child: Container(
                height: 100,
                width: 100,
                child: Text('Produtos'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ListaCategoriasPage(),
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
