import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:my_place/page/produto/form_produto_controller.dart';
import 'package:select_form_field/select_form_field.dart';

class FormProdutoPage extends StatefulWidget {
  FormProdutoPage(this.produto);

  final ProdutoModel produto;

  @override
  _FormProdutoPageState createState() => _FormProdutoPageState();
}

class _FormProdutoPageState extends State<FormProdutoPage> {
  FormProdutoController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = FormProdutoController(widget.produto ??
        ProdutoModel(
          imagens: [],
        ));
    super.initState();
  }

  Widget buildGridView() {
    if (_controller.images != null) {
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(_controller.images.length, (index) {
          Asset asset = _controller.images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    }
    return Container(color: Colors.white);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _controller.categoriasFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            final categorias = _controller.getCategoriasFromData(data.docs);
            return Padding(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SelectFormField(
                      initialValue: _controller.produto.categoria,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Categoria',
                      items: categorias
                          .map((categoria) => {
                                'value': categoria,
                                'label': categoria,
                              })
                          .toList(),
                      validator: (categoria) =>
                          categoria.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (categoria) =>
                          _controller.produto.categoria = categoria,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _controller.produto.nome,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Nome',
                      ),
                      validator: (nome) =>
                          nome.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (nome) => _controller.produto.nome = nome,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _controller.produto.descricao,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Descrição',
                      ),
                      validator: (descricao) =>
                          descricao.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (descricao) =>
                          _controller.produto.descricao = descricao,
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      onPressed: () async {
                        await _controller.loadAssets();
                        setState(() {});
                      },
                      child: Text('Escolher imagens'),
                    ),
                    CarouselSlider(
                      items: _controller.produto.imagens
                          .map(
                            (imagem) => Image.network(imagem),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 300,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    )
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
            await _controller.salvarProduto();
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
