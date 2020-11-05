import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_place_models/models/models.dart';

class FormCategoriaController {
  FormCategoriaController(this._categoria);

  CategoriaModel _categoria;
  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _firebaseStorage = FirebaseStorage.instance.ref();
  final _imagePicker = ImagePicker();

  CategoriaModel get categoria => _categoria;

  Future<String> escolheESalvaImagem(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      final image = await pickedFile.readAsBytes();
      final imageData = image.buffer.asUint8List();
      final uploadTask = _firebaseStorage
          .child('categorias')
          .child(imageData.hashCode.toString())
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
