import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widget/mp_appbar.dart';
import '../../widget/mp_button_icon.dart';
import '../../widget/mp_list_tile.dart';
import '../../widget/mp_list_view.dart';
import '../../widget/mp_loading.dart';
import 'form_categoria_page.dart';
import 'lista_categoria_controller.dart';

class ListaCategoriasPage extends StatelessWidget {
  final _controller = ListaCategoriaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text('Lista de Categorias'),
        actions: [
          MPButtonIcon(
            iconData: Icons.add,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FormCategoriaPage(null),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.categoriasStream(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final categorias =
                _controller.getCategoriasFromDocs(snapshot.data.docs);
            return MPListView(
              itemCount: categorias.length,
              itemBuilder: (_, i) {
                return MPListTile(
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FormCategoriaPage(categorias[i]),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Erro');
          } else {
            return MPLoading();
          }
        },
      ),
    );
  }
}
