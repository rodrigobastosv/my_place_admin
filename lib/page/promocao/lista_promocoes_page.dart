import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_place/widget/mp_appbar.dart';
import 'package:my_place/widget/mp_button_icon.dart';
import 'package:my_place/widget/mp_empty.dart';
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
          MPButtonIcon(
            iconData: Icons.add,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FormPromocaoPage(null),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.promocoesStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data.docs;
            if (docs.length == 0 || docs == null) {
              return MPEmpty();
            }
            final promocoes = _controller.getPromocoesFromData(docs);
            return MPListView(
              itemCount: promocoes.length,
              itemBuilder: (_, i) {
                final promocao = promocoes[i];
                return MPListTile(
                  leading: Icon(Icons.campaign),
                  title: Text(promocao.nomeProduto),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async => _controller.removePromocao(promocao),
                  ),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return MPLoading();
          } else {
            return MPEmpty();
          }
        },
      ),
    );
  }
}
