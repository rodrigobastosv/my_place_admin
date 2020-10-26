class PromocaoModel {
  String id;
  String idProduto;
  String nomeProduto;
  double desconto;

  PromocaoModel({
    this.id,
    this.idProduto,
    this.nomeProduto,
    this.desconto,
  });

  PromocaoModel.fromJson(String docId, Map<String, dynamic> json) {
    id = docId;
    idProduto = json['idProduto'];
    nomeProduto = json['nomeProduto'];
    desconto = json['desconto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduto'] = this.idProduto;
    data['nomeProduto'] = this.nomeProduto;
    data['desconto'] = this.desconto;
    return data;
  }
}
