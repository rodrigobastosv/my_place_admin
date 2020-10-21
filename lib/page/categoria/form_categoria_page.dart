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
  List<int> _imageData;
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

      setState(() {
        _imageData = image.buffer.asUint8List();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
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
                  hintText: 'Nome',
                ),
                validator: (nome) => nome.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (nome) => _categoria.nome = nome,
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: _categoria.descricao,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Descrição',
                ),
                validator: (descricao) =>
                    descricao.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (descricao) => _categoria.descricao = descricao,
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () async => getImage(),
                child: _categoria.urlImagem != null
                    ? Image.network(_categoria.urlImagem)
                    : Container(
                        height: 200,
                        width: 200,
                        child: _imageData == null
                            ? Text('Escolha a imagem')
                            : Image.memory(_imageData),
                      ),
              ),
            ],
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
              if (_imageData != null) {
                final uploadTask = _firebaseStorage
                    .child('categorias')
                    .child(_categoria.id)
                    .putData(_imageData);
                final onCompleteTask = await uploadTask.onComplete;
                final categoriaUrl = await onCompleteTask.ref.getDownloadURL();
                await _categoriasRef.doc(_categoria.id).update({
                  'urlImagem': categoriaUrl,
                });
              }
            } else {
              final categoria = await _categoriasRef.add(_categoria.toJson());
              if (_imageData != null) {
                final categoriaId = categoria.id;
                final uploadTask = _firebaseStorage
                    .child('categorias')
                    .child(categoriaId)
                    .putData(_imageData);
                final onCompleteTask = await uploadTask.onComplete;
                final categoriaUrl = await onCompleteTask.ref.getDownloadURL();
                await _categoriasRef.doc(categoriaId).update({
                  'urlImagem': categoriaUrl,
                });
              }
            }

            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
