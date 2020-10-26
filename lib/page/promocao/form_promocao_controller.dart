import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_place/model/produto_model.dart';
import 'package:my_place/model/promocao_model.dart';
import 'package:my_place/util/preco_utils.dart';

class FormPromocaoController {
  FormPromocaoController(this._promocao);

  final _produtosRef = FirebaseFirestore.instance.collection('produtos');
  final _promocoesRef = FirebaseFirestore.instance.collection('promocoes');

  final PromocaoModel _promocao;
  bool _isLoading = false;
  List<ProdutoModel> listaProdutos;

  PromocaoModel get promocao => _promocao;

  bool get isLoading => _isLoading;

  bool get temProdutoEscolhido => _promocao.idProduto != null;

  Future<List<ProdutoModel>> get getProdutosFuture => getProdutos();

  Future<List<ProdutoModel>> getProdutos() async {
    final querySnapshot = await _produtosRef.get();
    listaProdutos = querySnapshot.docs
        .map((doc) => ProdutoModel.fromJson(doc.id, doc.data()))
        .toList();
    return listaProdutos;
  }

  ProdutoModel getProdutoEscolhido() {
    return listaProdutos
        .firstWhere((produto) => produto.id == _promocao.idProduto);
  }

  double calculaPrecoComDesconto() {
    final produto = getProdutoEscolhido();
    final preco = double.parse(PrecoUtils.limpaStringPreco(produto.preco));
    return preco - ((preco * (_promocao.desconto ?? 0)) / 100);
  }

  Future<void> salvaPromocao() async {
    print(_promocao.desconto);
    await _promocoesRef.doc(_promocao.idProduto).set(_promocao.toJson());
  }

  void setDescontoPromocao(double desconto) {
    _promocao.desconto = desconto;
  }

  void setInfoProdutoPromocao(String produtoId) {
    final produto = listaProdutos.firstWhere((prod) => prod.id == produtoId);
    if (produto != null) {
      _promocao.idProduto = produto.id;
      _promocao.nomeProduto = produto.nome;
      _promocao.valorOriginalProduto = double.parse(PrecoUtils.limpaStringPreco(produto.preco));
    }
  }
}
