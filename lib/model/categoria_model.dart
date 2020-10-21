class CategoriaModel {
  String id;
  String nome;
  String descricao;
  String urlImagem;

  CategoriaModel({this.id, this.nome, this.descricao, this.urlImagem});

  CategoriaModel.fromJson(String docId, Map<String, dynamic> json) {
    id = docId;
    nome = json['nome'];
    descricao = json['descricao'];
    urlImagem = json['urlImagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['urlImagem'] = this.urlImagem;
    return data;
  }
}