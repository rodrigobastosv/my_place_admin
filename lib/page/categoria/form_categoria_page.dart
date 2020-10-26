import 'package:flutter/material.dart';
import 'package:my_place/model/categoria_model.dart';
import 'package:my_place/page/categoria/form_categoria_controller.dart';

class FormCategoriaPage extends StatefulWidget {
  FormCategoriaPage(this.categoria);

  final CategoriaModel categoria;

  @override
  _FormCategoriaPageState createState() => _FormCategoriaPageState();
}

class _FormCategoriaPageState extends State<FormCategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  FormCategoriaController _controller;

  @override
  void initState() {
    _controller = FormCategoriaController(
      widget.categoria ?? CategoriaModel(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight:
                  _controller.categoria.urlImagem == null ? 40 : 200,
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
                      _controller.setUrlImagemCategoria(urlImagem);
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
                    _controller.categoria.nome == null
                        ? 'Criar Categoria'
                        : 'Editar Categoria',
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
                  tag: _controller.categoria.id ?? '',
                  child: _controller.categoria.urlImagem == null
                      ? SizedBox()
                      : Image.network(
                          _controller.categoria.urlImagem,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _controller.categoria.nome ?? '',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Nome',
                    hintText: 'Nome',
                  ),
                  validator: (nome) =>
                      nome.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: _controller.setNomeCategoria,
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _controller.categoria.descricao ?? '',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Descrição',
                    hintText: 'Descrição',
                  ),
                  validator: (descricao) =>
                      descricao.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: _controller.setDescricaoCategoria,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            await _controller.salvaCategoria();
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
