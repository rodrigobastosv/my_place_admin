import 'package:flutter/material.dart';

class PrecoDescontoProduto extends StatelessWidget {
  PrecoDescontoProduto({
    this.desconto,
    this.preco,
  });

  final double desconto;
  final double preco;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Text(
          'Com o desconto de ${desconto ?? '0'} %, o preço de venda do produto será ${preco.toStringAsFixed(2)}'),
    );
  }
}
