class UsuarioModel {
  String nome;
  String email;

  UsuarioModel({this.nome, this.email});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
  }
}