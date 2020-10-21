import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/model/categoria_model.dart';
import 'package:my_place/page/categoria/form_categoria_page.dart';
import 'package:my_place/page/produto/form_produto_page.dart';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  final Stream<QuerySnapshot> categoriasStream =
      FirebaseFirestore.instance.collection('categorias').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Categorias'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriasStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            final categorias = List.generate(docs.length, (i) {
              final categoriaDoc = docs[i];
              return CategoriaModel.fromJson(
                categoriaDoc.id,
                categoriaDoc.data(),
              );
            });
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
                  leading: categorias[i].urlImagem != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            categorias[i].urlImagem,
                          ),
                        )
                      : Icon(Icons.category),
                  title: Text(categorias[i].nome),
                );
              },
              itemCount: categorias.length,
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
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
              builder: (_) => FormProdutoPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
