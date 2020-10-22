import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_place/model/categoria_model.dart';

class FormCategoriaPage extends StatefulWidget {
  FormCategoriaPage(this.categoria);

  final CategoriaModel categoria;

  @override
  _FormCategoriaPageState createState() => _FormCategoriaPageState();
}

class _FormCategoriaPageState extends State<FormCategoriaPage> {
  CategoriaModel _categoria;
  final _formKey = GlobalKey<FormState>();

  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _firebaseStorage = FirebaseStorage.instance.ref();

  @override
  void initState() {
    _categoria = widget.categoria ?? CategoriaModel();
    super.initState();
  }

  Future<void> getImage() async {
    final file = await MultiImagePicker.pickImages(
      enableCamera: true,
      maxImages: 1,
    );
    if (file != null) {
      final image = await file[0].getByteData();
      final imageData = image.buffer.asUint8List();
      await _firebaseStorage.child('categorias').child(_categoria.id).delete();
      final uploadTask = _firebaseStorage
          .child('categorias')
          .child(_categoria.id)
          .putData(imageData);
      final onCompleteTask = await uploadTask.onComplete;
      final categoriaUrl = await onCompleteTask.ref.getDownloadURL();
      setState(() {
        _categoria.urlImagem = categoriaUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async => getImage(),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  _categoria.nome,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Image.network(
                  _categoria.urlImagem,
                  fit: BoxFit.cover,
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
                  initialValue: _categoria.nome,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Nome',
                    hintText: 'Nome',
                  ),
                  validator: (nome) =>
                      nome.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: (nome) => _categoria.nome = nome,
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _categoria.descricao,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Descrição',
                    hintText: 'Descrição',
                  ),
                  validator: (descricao) =>
                      descricao.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: (descricao) => _categoria.descricao = descricao,
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
            if (_categoria.id != null) {
              await _categoriasRef
                  .doc(_categoria.id)
                  .update(_categoria.toJson());
            }
          } else {
            await _categoriasRef.add(_categoria.toJson());
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
