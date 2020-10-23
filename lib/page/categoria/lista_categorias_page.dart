import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/page/categoria/form_categoria_page.dart';

import 'lista_categoria_controller.dart';

class ListaCategoriasPage extends StatelessWidget {
  final _controller = ListaCategoriaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Lista de Categorias'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.getCategoriasStream(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final categorias =
                _controller.getCategoriasFromDocs(snapshot.data.docs);
            return ListView.builder(
              itemBuilder: (_, i) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FormCategoriaPage(categorias[i]),
                      ),
                    );
                  },
                  leading: Hero(
                    tag: categorias[i].id,
                    child: categorias[i].urlImagem != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            categorias[i].urlImagem,
                          ),
                        )
                      : Icon(Icons.category),
                  ),
                  title: Text(categorias[i].nome),
                );
              },
              itemCount: categorias.length,
            );
          } else if (snapshot.hasError) {
            return Text('Erro');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FormCategoriaPage(null),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}