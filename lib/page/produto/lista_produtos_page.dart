import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/page/produto/form_produto_page.dart';
import 'package:my_place/page/produto/lista_produto_controller.dart';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  final _controller = ListaProdutoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.produtosStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            final produtos = _controller.getProdutosFromData(docs);
            return ListView.builder(
              itemBuilder: (_, i) {
                final produto = produtos[i];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FormProdutoPage(produto),
                      ),
                    );
                  },
                  leading: produto.imagens.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            produto.imagens[0],
                          ),
                        )
                      : Icon(Icons.indeterminate_check_box),
                  title: Text(produto.nome),
                );
              },
              itemCount: produtos.length,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FormProdutoPage(null),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
