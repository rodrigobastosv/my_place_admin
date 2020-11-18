import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_place/page/pedidos_finalizados/pedidos_finalizados_page.dart';
import 'package:my_place/page/pedidos_pendentes/pedidos_pendentes_page.dart';
import 'package:my_place/page/promocao/lista_promocoes_page.dart';
import 'package:my_place/widget/mp_logo.dart';
import 'package:my_place/widget/mp_appbar.dart';

import 'package:my_place_models/models/models.dart';
import '../categoria/lista_categorias_page.dart';
import '../produto/lista_produtos_page.dart';

class HomePage extends StatelessWidget {
  HomePage(this.usuario);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: MPLogo(fontSize: 24),
        withLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _Button(
              text: 'Categorias',
              iconData: Icons.category,
              page: ListaCategoriasPage(),
            ),
            _Button(
              text: 'Produtos',
              iconData: Icons.fastfood,
              page: ListaProdutosPage(),
            ),
            _Button(
              text: 'Promoções',
              iconData: Icons.campaign,
              page: ListaPromocoesPage(),
            ),
            _Button(
              text: 'Pedidos Pendentes',
              iconData: Icons.pending,
              page: PedidosPendentesPage(),
            ),
            _Button(
              text: 'Pedidos Finalizados',
              iconData: Icons.flag,
              page: PedidosFinalizadosPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget page;
  final IconData iconData;
  final String text;

  const _Button({
    this.page,
    this.iconData,
    this.text,
  })  : assert(page != null),
        assert(iconData != null),
        assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        child: Container(
          width: 100,
          height: 90,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
