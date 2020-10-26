import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/widget/mp_appbar.dart';
import 'package:my_place/widget/mp_list_tile.dart';
import 'package:my_place/widget/mp_list_view.dart';
import 'package:my_place/widget/mp_loading.dart';

import 'form_promocao_page.dart';
import 'lista_promocoes_controller.dart';

class ListaPromocoesPage extends StatefulWidget {

  @override
  _ListaPromocoesPageState createState() => _ListaPromocoesPageState();
}

class _ListaPromocoesPageState extends State<ListaPromocoesPage> {
  final _controller = ListaPromocoesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text('Lista de Promoções'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FormPromocaoPage(null),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.promocoesStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            final promocoes = _controller.getPromocoesFromData(docs);
            return MPListView(
              itemCount: promocoes.length,
              itemBuilder: (_, i) {
                final promocao = promocoes[i];
                return MPListTile(
                  leading: Icon(Icons.campaign),
                  title: Text(promocao.nomeProduto),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FormPromocaoPage(promocao),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return MPLoading();
          }
        },
      ),
    );
  }
}