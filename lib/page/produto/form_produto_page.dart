import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:my_place/page/produto/form_produto_controller.dart';
import 'package:my_place/util/preco_utils.dart';
import 'package:my_place/widget/mp_button_icon.dart';
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
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 240,
                collapsedHeight: 40,
                toolbarHeight: 38,
                elevation: 0.5,
                floating: false,
                pinned: true,
                title: Text(
                  _controller.produto.nome == null
                      ? 'Criar Produto'
                      : 'Editar Produto',
                ),
                leadingWidth: 40,
                leading: MPButtonIcon(
                  iconData: Icons.chevron_left,
                  onTap: () => Navigator.pop(context),
                ),
                actions: [
                  MPButtonIcon(
                    iconData: Icons.check,
                    onTap: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        await _controller.salvarProduto();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.maxFinite,
                            color: Theme.of(context).colorScheme.surface,
                            child: _controller.produto.urlImagem.isEmpty
                                ? Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 100,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  )
                                : Hero(
                                    tag: _controller.produto.id ?? '',
                                    child: Image.network(
                                      _controller.produto.urlImagem,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(.7),
                            child: PopupMenuButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                              ),
                              itemBuilder: (_) => [
                                PopupMenuItem<String>(
                                  value: 'Camera',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Camera'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Galeria',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.photo_library,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Galeria'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (valor) async {
                                final urlImagem =
                                    await _controller.escolheESalvaImagem(
                                  valor == 'Camera'
                                      ? ImageSource.camera
                                      : ImageSource.gallery,
                                );
                                setState(() {
                                  _controller.setUrlImagemProduto(urlImagem);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<QuerySnapshot>(
                future: _controller.categoriasFuture,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    final categorias =
                        _controller.getCategoriasFromData(data.docs);
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            child: SelectFormField(
                              initialValue: _controller.produto.categoria,
                              labelText: 'Categoria',
                              items: categorias
                                  .map((categoria) => {
                                        'value': categoria,
                                        'label': categoria,
                                      })
                                  .toList(),
                              validator: (categoria) => categoria.isEmpty
                                  ? 'Campo Obrigatório'
                                  : null,
                              onSaved: (categoria) =>
                                  _controller.produto.categoria = categoria,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 300,
                            child: TextFormField(
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
                              onSaved: (nome) =>
                                  _controller.produto.nome = nome,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 400,
                            child: TextFormField(
                              initialValue: _controller.produto.descricao,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText:
                                    'Texto a ser mostrado para o cliente...',
                                labelText: 'Descrição',
                              ),
                              validator: (descricao) => descricao.isEmpty
                                  ? 'Campo Obrigatório'
                                  : null,
                              onSaved: (descricao) =>
                                  _controller.produto.descricao = descricao,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 150,
                            child: TextFormField(
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
                                } else if (PrecoUtils.getNumeroStringPreco(
                                        preco) ==
                                    0) {
                                  return 'O preço do produto não pode ser 0.';
                                }
                                return null;
                              },
                              onSaved: _controller.setPrecoProduto,
                              onChanged: (preco) =>
                                  _precoController.text = preco,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: MPLoading(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
