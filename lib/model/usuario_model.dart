class UsuarioModel {
  String nome;
  String email;
  String tipo;

  UsuarioModel({
    this.nome,
    this.email,
    this.tipo,
  });

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    tipo = json['tipo'];
  }
}
