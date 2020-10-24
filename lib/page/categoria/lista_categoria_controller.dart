import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place/model/categoria_model.dart';

class ListaCategoriaController {
  final Stream<QuerySnapshot> _categoriasStream =
      FirebaseFirestore.instance.collection('categorias').snapshots();

  Stream<QuerySnapshot> categoriasStream() => _categoriasStream;

  List<CategoriaModel> getCategoriasFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final categoriaDoc = docs[i];
      return CategoriaModel.fromJson(
        categoriaDoc.id,
        categoriaDoc.data(),
      );
    });
  }
}
