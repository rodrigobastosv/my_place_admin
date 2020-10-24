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
    _controller = FormCategoriaController(widget.categoria ?? CategoriaModel());
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
                  _controller.categoria.urlImagem == null ? 60 : 140,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                  icon: Icon(Icons.camera),
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
                title: Text(
                  _controller.categoria.nome ?? 'Criar Categoria',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Hero(
                  tag: widget.categoria.id ?? '',
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
          padding: const EdgeInsets.all(22),
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
