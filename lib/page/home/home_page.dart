import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_place/page/promocao/lista_promocoes_page.dart';
import 'package:my_place/widget/mp_logo.dart';
import 'package:my_place/widget/mp_appbar.dart';

import '../../model/usuario_model.dart';
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
          direction: Axis.vertical,
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
          width: 185,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 6),
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
