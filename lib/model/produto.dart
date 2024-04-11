class Produto {
  int? id;
  String? nome;
  int? valor;
  String? categoria;

  Produto({
    this.id,
    this.nome,
    this.valor,
    this.categoria,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
      'categoria': categoria,
    };
  }

  @override
  String toString() {
    return 'Produto { nome: $nome, valor: $valor, categoria: $categoria}';
  }
}
