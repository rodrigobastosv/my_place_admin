import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/widget/mp_empty.dart';

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
            if (categorias.length == 0 || categorias == null) {
              return MPEmpty();
            }
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async => _controller.removeCategoria(categorias[i]),
                  ),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return MPLoading();
          } else {
            return MPEmpty();
          }
        },
      ),
    );
  }
}
