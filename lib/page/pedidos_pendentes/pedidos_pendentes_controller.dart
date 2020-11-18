import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place_models/models/models.dart';

class PedidosPendentesController {
  CollectionReference pedidosPendentesRef =
      FirebaseFirestore.instance.collection('pedidos_pendentes');
  CollectionReference pedidosFinalizadosRef =
      FirebaseFirestore.instance.collection('pedidos_finalizados');
  final Stream<QuerySnapshot> _pedidosPendentesStream = FirebaseFirestore
      .instance
      .collection('pedidos_pendentes')
      .snapshots();

  Stream<QuerySnapshot> pedidosPendentesStream() => _pedidosPendentesStream;

  List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(
        pedidoDoc.id,
        pedidoDoc.data(),
      );
    });
  }

  Future<void> finalizarPedido(PedidoModel pedido) async {
    await pedidosFinalizadosRef.doc(pedido.id).set(pedido.toJson());
    await pedidosPendentesRef.doc(pedido.id).delete();
  }
}
