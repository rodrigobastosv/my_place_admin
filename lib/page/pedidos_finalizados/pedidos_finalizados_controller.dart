import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place_models/models/models.dart';

class PedidosFinalizadosController {
  CollectionReference pedidosFinalizadosRef =
      FirebaseFirestore.instance.collection('pedidos_finalizados');

  final Stream<QuerySnapshot> _pedidosFinalizadosStream = FirebaseFirestore
      .instance
      .collection('pedidos_finalizados')
      .snapshots();

  Stream<QuerySnapshot> pedidosFinalizadosStream() => _pedidosFinalizadosStream;

  List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(
        pedidoDoc.id,
        pedidoDoc.data(),
      );
    });
  }
}
