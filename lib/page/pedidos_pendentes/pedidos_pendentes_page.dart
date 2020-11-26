import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_place/widget/mp_appbar.dart';
import 'package:my_place/widget/mp_empty.dart';
import 'package:my_place/widget/mp_list_view.dart';
import 'package:my_place/widget/mp_loading.dart';
import 'package:my_place_models/models/models.dart';

import 'pedidos_pendentes_controller.dart';

class PedidosPendentesPage extends StatelessWidget {
  final PedidosPendentesController _controller = PedidosPendentesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text('Pedidos Pendentes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.pedidosPendentesStream(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final pedidos = _controller.getPedidosFromDocs(snapshot.data.docs);
            if (pedidos.length == 0 || pedidos == null) {
              return MPEmpty();
            }
            return MPListView(
              itemCount: pedidos.length,
              itemBuilder: (_, i) {
                return Dismissible(
                  key: Key(pedidos[i].id),
                  onDismissed: (direction) async {
                    await _controller.finalizarPedido(pedidos[i]);
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Confirmação'),
                          content: Text(
                              'Tem certeza que deseja finalizar este pedido?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('SIM'),
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('NÃO'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ExpansionTile(
                    title: Text(DateFormat("d MMM y 'às' HH:mm", 'pt_br')
                        .format(DateFormat('yyyy-MM-dd HH:mm:ss')
                            .parse(pedidos[i].dataPedido.toString()))),
                    subtitle: Text(
                      pedidos[i].nomeUsuario ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    trailing: Text(
                      'R\$ ${pedidos[i].valorPedido.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    children: getProdutos(pedidos[i].produtos),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return MPLoading();
          } else {
            return MPEmpty();
          }
        },
      ),
    );
  }

  List<Widget> getProdutos(List<ProdutoModel> produtos) {
    if (produtos != null) {
      return produtos
          .map(
            (produto) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(produto.urlImagem),
              ),
              title: Text(produto.nome),
              trailing: Text(produto.quantidade.toString()),
            ),
          )
          .toList();
    }
    return [];
  }
}
