class PromocaoModel {
  String id;
  String idProduto;
  String nomeProduto;
  double valorOriginalProduto;
  double desconto;

  PromocaoModel({
    this.id,
    this.idProduto,
    this.nomeProduto,
    this.valorOriginalProduto,
    this.desconto,
  });

  PromocaoModel.fromJson(String docId, Map<String, dynamic> json) {
    id = docId;
    idProduto = json['idProduto'];
    nomeProduto = json['nomeProduto'];
    valorOriginalProduto = json['valorOriginalProduto'];
    desconto = json['desconto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduto'] = this.idProduto;
    data['nomeProduto'] = this.nomeProduto;
    data['valorOriginalProduto'] = this.valorOriginalProduto;
    data['desconto'] = this.desconto;
    return data;
  }
}
