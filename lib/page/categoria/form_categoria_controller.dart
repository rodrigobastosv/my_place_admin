import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_place/model/categoria_model.dart';

class FormCategoriaController {
  FormCategoriaController(this._categoria);

  CategoriaModel _categoria;
  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _firebaseStorage = FirebaseStorage.instance.ref();

  CategoriaModel get categoria => _categoria;

  Future<String> escolheESalvaImagem() async {
    final file = await MultiImagePicker.pickImages(
      enableCamera: true,
      maxImages: 1,
    );
    if (file != null) {
      final image = await file[0].getByteData();
      final imageData = image.buffer.asUint8List();
      final uploadTask = _firebaseStorage
          .child('categorias')
          .child(_categoria.id)
          .putData(imageData);
      final onCompleteTask = await uploadTask.onComplete;
      final categoriaUrl = await onCompleteTask.ref.getDownloadURL();
      return categoriaUrl;
    }
    return null;
  }

  Future<void> salvaCategoria() async {
    if (_categoria.id != null) {
      await _categoriasRef.doc(_categoria.id).update(_categoria.toJson());
    } else {
      await _categoriasRef.add(_categoria.toJson());
    }
  }

  void setNomeCategoria(String nome) => _categoria.nome = nome;

  void setDescricaoCategoria(String descricao) =>
      _categoria.descricao = descricao;

  void setUrlImagemCategoria(String urlImagem) =>
      _categoria.urlImagem = urlImagem;
}