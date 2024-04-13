class Configuracao {
  int? id;
  String? tema;
  String? idioma;

  Configuracao({
    this.id,
    this.tema,
    this.idioma,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tema': tema,
      'idioma': idioma,
    };
  }

  @override
  String toString() {
    return 'Config { nome: $tema, valor: $idioma}';
  }
}
