import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/page/produto/form_produto_page.dart';
import 'package:my_place/page/produto/lista_produto_controller.dart';
import 'package:my_place/widget/mp_appbar.dart';
import 'package:my_place/widget/mp_button_icon.dart';
import 'package:my_place/widget/mp_list_tile.dart';
import 'package:my_place/widget/mp_list_view.dart';
import 'package:my_place/widget/mp_loading.dart';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  final _controller = ListaProdutoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text('Lista de Produtos'),
        actions: [
          MPButtonIcon(
            iconData: Icons.add,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FormProdutoPage(null),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.produtosStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            final produtos = _controller.getProdutosFromData(docs);
            return MPListView(
              itemCount: produtos.length,
              itemBuilder: (_, i) {
                final produto = produtos[i];
                return MPListTile(
                  leading: produto.urlImagem != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            produto.urlImagem,
                          ),
                        )
                      : Icon(Icons.fastfood),
                  title: Text(produto.nome),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FormProdutoPage(produto),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return MPLoading();
          }
        },
      ),
    );
  }
}
