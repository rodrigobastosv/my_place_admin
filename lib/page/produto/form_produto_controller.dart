import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_place/model/produto_model.dart';

class FormProdutoController {
  FormProdutoController(this._produto);

  ProdutoModel _produto;
  List<Asset> _images = List<Asset>();

  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');
  final _firebaseStorage = FirebaseStorage.instance.ref();

  ProdutoModel get produto => _produto;

  Future<QuerySnapshot> get categoriasFuture => _categoriasRef.get();

  List<Asset> get images => _images;

  List<String> getCategoriasFromData(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final doc = docs[i];
      return doc.data()['nome'];
    });
  }

  Future<void> loadAssets() async {
    _images = await MultiImagePicker.pickImages(
      enableCamera: true,
      maxImages: 8,
    );
  }

  Future<void> salvarProduto() async {
    String produtoId;
    if (_produto.id != null) {
      produtoId = _produto.id;
      await _produtosRef.doc(_produto.id).update(_produto.toJson());
    } else {
      final doc = await _produtosRef.add(_produto.toJson());
      produtoId = doc.id;
    }
    if (images.isNotEmpty) {
      final imagensProdutos = [];
      images.asMap().forEach((i, image) async {
        final imageData = await image.getByteData();
        final data = imageData.buffer.asUint8List();
        final uploadTask = _firebaseStorage
            .child('produtos')
            .child(produtoId)
            .child(i.toString())
            .putData(data);
        final onCompleteTask = await uploadTask.onComplete;
        final imagemUrl = await onCompleteTask.ref.getDownloadURL();
        imagensProdutos.add(imagemUrl);
        await _produtosRef.doc(produtoId).update({
          'imagens': imagensProdutos,
        });
      });
    }
  }
}
