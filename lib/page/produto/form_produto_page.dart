import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:select_form_field/select_form_field.dart';

class FormProdutoPage extends StatefulWidget {
  FormProdutoPage(this.produto);

  final ProdutoModel produto;

  @override
  _FormProdutoPageState createState() => _FormProdutoPageState();
}

class _FormProdutoPageState extends State<FormProdutoPage> {
  ProdutoModel _produto;
  List<Asset> images = List<Asset>();
  Future<QuerySnapshot> _categoriasFuture;
  final _formKey = GlobalKey<FormState>();

  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');
  final _firebaseStorage = FirebaseStorage.instance.ref();

  @override
  void initState() {
    _categoriasFuture = _categoriasRef.get();
    _produto = widget.produto ?? ProdutoModel();
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
      );
    } on Exception {}

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _categoriasFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            final categorias = data.docs.map((doc) => doc.data()['nome']);
            return Padding(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SelectFormField(
                      initialValue: _produto.categoria,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Categoria',
                      items: categorias.map((categoria) => {
                        'value': categoria,
                        'label': categoria,
                      }).toList(),
                      validator: (categoria) => categoria.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (categoria) => _produto.categoria = categoria,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _produto.nome,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Nome',
                      ),
                      validator: (nome) =>
                          nome.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (nome) => _produto.nome = nome,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _produto.descricao,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Descrição',
                      ),
                      validator: (descricao) =>
                          descricao.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (descricao) => _produto.descricao = descricao,
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      onPressed: () async {
                        images = await MultiImagePicker.pickImages(
                          enableCamera: true,
                          maxImages: 8,
                          materialOptions: MaterialOptions(
                            actionBarTitle: "Action bar",
                            allViewTitle: "All view title",
                            actionBarColor: "#aaaaaa",
                            actionBarTitleColor: "#bbbbbb",
                            lightStatusBar: false,
                            statusBarColor: '#abcdef',
                            startInAllView: true,
                            selectCircleStrokeColor: "#000000",
                            selectionLimitReachedText:
                                "You can't select any more.",
                          ),
                        );
                        setState(() {});
                      },
                      child: Text('Escolher imagens'),
                    ),
                    Expanded(
                      child: buildGridView(),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            String produtoId;
            if (_produto.id != null) {
              produtoId = _produto.id;
              await _produtosRef.doc(_produto.id).update(_produto.toJson());
            } else {
              final doc = await _produtosRef.add(_produto.toJson());
              produtoId = doc.id;
            }
            if (images.isNotEmpty) {
              final imagensProdutos = [];
              images.asMap().forEach((i, image) async {
                final imageData = await image.getByteData();
                final data = imageData.buffer.asUint8List();
                final uploadTask = _firebaseStorage
                    .child('produtos')
                    .child(produtoId)
                    .child(i.toString())
                    .putData(data);
                final onCompleteTask = await uploadTask.onComplete;
                final imagemUrl = await onCompleteTask.ref.getDownloadURL();
                imagensProdutos.add(imagemUrl);
                await _produtosRef.doc(produtoId).update({
                  'imagens': imagensProdutos,
                });
              });
            }
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
