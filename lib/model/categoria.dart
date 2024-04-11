class Categoria {
  int? id;
  String? nome;

  Categoria({
    this.id,
    this.nome,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  @override
  String toString() {
    return 'Categoria { nome: $nome}';
  }
}
