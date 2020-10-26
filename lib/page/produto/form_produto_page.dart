import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:my_place/page/produto/form_produto_controller.dart';
import 'package:my_place/util/preco_utils.dart';
import 'package:my_place/widget/mp_loading.dart';
import 'package:select_form_field/select_form_field.dart';

class FormProdutoPage extends StatefulWidget {
  FormProdutoPage(this.produto);

  final ProdutoModel produto;

  @override
  _FormProdutoPageState createState() => _FormProdutoPageState();
}

class _FormProdutoPageState extends State<FormProdutoPage> {
  FormProdutoController _controller;
  MoneyMaskedTextController _precoController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = FormProdutoController(
      widget.produto ??
          ProdutoModel(
            urlImagem: '',
          ),
    );
    _precoController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    )..text = _controller.produto.preco;
    super.initState();
  }

  @override
  void dispose() {
    _precoController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: _controller.produto.urlImagem == null ? 40 : 200,
              collapsedHeight: 40,
              toolbarHeight: 38,
              elevation: 0.5,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: 32,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    final urlImagem = await _controller.escolheESalvaImagem();
                    setState(() {
                      _controller.setUrlImagemProduto(urlImagem);
                    });
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsetsDirectional.only(
                  start: 0,
                  bottom: 0,
                ),
                title: Container(
                  color: Theme.of(context).appBarTheme.color,
                  width: double.maxFinite,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 9),
                  child: Text(
                    _controller.produto.nome == null
                        ? 'Criar Produto'
                        : 'Editar Produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .appBarTheme
                          .textTheme
                          .headline6
                          .color,
                    ),
                  ),
                ),
                background: Hero(
                  tag: _controller.produto.id ?? '',
                  child: _controller.produto.urlImagem == null
                      ? SizedBox()
                      : Image.network(
                          _controller.produto.urlImagem,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder<QuerySnapshot>(
          future: _controller.categoriasFuture,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              final categorias = _controller.getCategoriasFromData(data.docs);
              return Padding(
                padding: const EdgeInsets.all(16),
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
                          hintText: 'Escreva o nome do produto...',
                          labelText: 'Nome',
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
                          hintText: 'Texto a ser mostrado para o cliente...',
                          labelText: 'Descrição',
                        ),
                        validator: (descricao) =>
                            descricao.isEmpty ? 'Campo Obrigatório' : null,
                        onSaved: (descricao) =>
                            _controller.produto.descricao = descricao,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _precoController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"\d+"),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Preço',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (preco) {
                          if (preco == null || preco == 'R\$') {
                            return 'Campo Obrigatório';
                          } else if (PrecoUtils.getNumeroStringPreco(preco) ==
                              0) {
                            return 'O preço do produto não pode ser 0.';
                          }
                          return null;
                        },
                        onSaved: _controller.setPrecoProduto,
                        onChanged: (preco) => _precoController.text = preco,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: MPLoading(),
            );
          },
        ),
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
