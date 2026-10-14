class UserModel {
  final String id;
  String nome;
  final String email;
  String telefone;
  final String? fotoUrl;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    this.fotoUrl,
  });

  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? fotoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}
