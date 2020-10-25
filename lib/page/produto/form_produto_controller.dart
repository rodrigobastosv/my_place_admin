import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_place/model/produto_model.dart';

class FormProdutoController {
  FormProdutoController(this._produto);

  ProdutoModel _produto;

  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');
  final _firebaseStorage = FirebaseStorage.instance.ref();
  final _imagePicker = ImagePicker();

  ProdutoModel get produto => _produto;

  Future<QuerySnapshot> get categoriasFuture => _categoriasRef.get();

  List<String> getCategoriasFromData(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final doc = docs[i];
      return doc.data()['nome'];
    });
  }

  Future<String> escolheESalvaImagem() async {
    final pickedFile = await _imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final image = await pickedFile.readAsBytes();
      final imageData = image.buffer.asUint8List();
      final uploadTask = _firebaseStorage
          .child('produtos')
          .child(imageData.hashCode.toString())
          .putData(imageData);
      final onCompleteTask = await uploadTask.onComplete;
      final produtoUrl = await onCompleteTask.ref.getDownloadURL();
      return produtoUrl;
    }
    return null;
  }

  Future<void> salvarProduto() async {
    if (_produto.id != null) {
      await _produtosRef.doc(_produto.id).update(_produto.toJson());
    } else {
      await _produtosRef.add(_produto.toJson());
    }
  }

  void setUrlImagemProduto(String urlImagem) =>
      _produto.urlImagem = urlImagem;

  void setPrecoProduto(String preco) =>
      _produto.preco = preco; 
}
