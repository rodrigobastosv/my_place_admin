import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place/model/promocao_model.dart';

class ListaPromocoesController {
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
}