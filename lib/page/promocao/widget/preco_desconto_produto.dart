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
      width: 300,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '''Com o desconto de ${desconto ?? '0'}%,'''
        '''\no preço de venda do produto será R\$ ${preco.toStringAsFixed(2)}''',
      ),
    );
  }
}
