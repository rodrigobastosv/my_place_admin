import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place_models/models/models.dart';

class ListaPromocoesController {
  CollectionReference promocoesRef =
      FirebaseFirestore.instance.collection('promocoes');
  final Stream<QuerySnapshot> _promocoesStream =
      FirebaseFirestore.instance.collection('promocoes').snapshots();

  Stream<QuerySnapshot> get promocoesStream => _promocoesStream;

  List<PromocaoModel> getPromocoesFromData(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final promocaoDoc = docs[i];
      return PromocaoModel.fromJson(
        promocaoDoc.id,
        promocaoDoc.data(),
      );
    });
  }

  Future<void> removePromocao(PromocaoModel promocao) async {
    try {
      await promocoesRef.doc(promocao.id).delete();
    } on Exception {
      rethrow;
    }
  }
}