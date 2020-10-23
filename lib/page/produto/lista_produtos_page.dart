import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:my_place/page/produto/form_produto_page.dart';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  final Stream<QuerySnapshot> produtosStream =
      FirebaseFirestore.instance.collection('produtos').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: produtosStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            final produtos = List.generate(docs.length, (i) {
              final produtoDoc = docs[i];
              return ProdutoModel.fromJson(
                produtoDoc.id,
                produtoDoc.data(),
              );
            });
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
              builder: (_) => FormProdutoPage(null),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
