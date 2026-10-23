class Livro {
  String? _id;
  String _titulo;
  String _autor;
  int _paginas;
  String _categoria;

  Livro(
      this._titulo,
      this._autor,
      this._paginas,
      this._categoria,
      );

  Livro.withId(
      this._id,
      this._titulo,
      this._autor,
      this._paginas,
      this._categoria,
      );

  String? get id => _id;
  String get titulo => _titulo;
  String get autor => _autor;
  int get paginas => _paginas;
  String get categoria => _categoria;

  set titulo(String novoTitulo) {
    _titulo = novoTitulo;
  }

  set autor(String novoAutor) {
    _autor = novoAutor;
  }

  set paginas(int novasPaginas) {
    _paginas = novasPaginas;
  }

  set categoria(String novaCategoria) {
    _categoria = novaCategoria;
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': _titulo,
      'autor': _autor,
      'paginas': _paginas,
      'categoria': _categoria,
    };
  }

  factory Livro.fromFirestore(
      Map<String, dynamic> dados,
      String id,
      ) {
    return Livro.withId(
      id,
      dados['titulo'] as String,
      dados['autor'] as String,
      (dados['paginas'] as num).toInt(),
      dados['categoria'] as String,
    );
  }
}