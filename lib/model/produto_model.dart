class ProdutoModel {
  String id;
  String nome;
  String descricao;
  List<String> imagens;

  ProdutoModel({this.nome, this.descricao, this.imagens});

  ProdutoModel.fromJson(String docId, Map<String, dynamic> json) {
    id = docId;
    nome = json['nome'];
    descricao = json['descricao'];
    final imagensList = json['imagens'] as List<dynamic> ?? [];
    final imagensUrls =
        List.generate(imagensList.length, (i) => imagensList[i].toString());
    imagens = imagensUrls;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['imagens'] = this.imagens;
    return data;
  }
}
