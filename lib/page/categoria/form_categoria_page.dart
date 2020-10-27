import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                  _controller.categoria.nome == null
                      ? 'Criar Categoria'
                      : 'Editar Categoria',
                ),
                leading: IconButton(
                  icon: Icon(Icons.chevron_left),
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        await _controller.salvaCategoria();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
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
                            child: _controller.categoria.urlImagem == null
                                ? Image.asset(
                                    'assets/imagens/produtos.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Hero(
                                    tag: _controller.categoria.id ?? '',
                                    child: Image.network(
                                      _controller.categoria.urlImagem,
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
                                      Text(
                                        'Camera',
                                      ),
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
                                      Text(
                                        'Galeria',
                                      ),
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
                                  _controller.setUrlImagemCategoria(urlImagem);
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: TextFormField(
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
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 400,
                      child: TextFormField(
                        initialValue: _controller.categoria.descricao ?? '',
                        maxLines: 5,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
