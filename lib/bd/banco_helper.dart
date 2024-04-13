import 'dart:async';
import 'package:catalago_produto_flutter/model/categoria.dart';
import 'package:catalago_produto_flutter/model/configuracao.dart';
import 'package:catalago_produto_flutter/model/produto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD12.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  // Produto
  static const tabelaProduto = 'produtos';
  static const tabelaCategoria = 'categorias';
  static const tabelaConfiguracao = 'configuracoes';
  static const colunaId = 'id';
  static const colunaNome = 'nome';
  static const colunaValor = 'valor';
  static const colunaCategoria = 'categoria';
  static const colunaTema = 'tema';
  static const colunaIdioma = 'idioma';

  static late Database _bancoDeDados;

  iniciarBD() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    _bancoDeDados = await openDatabase(path,
        version: arquivoDoBancoDeDadosVersao,
        onCreate: funcaoCriacaoBD,
        onUpgrade: funcaoAtualizarBD,
        onDowngrade: funcaoDowngradeBD);
  }

  Future funcaoCriacaoBD(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelaProduto (
          $colunaId INTEGER PRIMARY KEY,
          $colunaNome TEXT NOT NULL,
          $colunaValor REAL NOT NULL,
          $colunaCategoria TEXT NOT NULL
        )
      ''');

    await db.execute('''
         CREATE TABLE $tabelaCategoria (
          $colunaId INTEGER PRIMARY KEY,
          $colunaNome TEXT NOT NULL
        )
      ''');

    await db.execute('''
         CREATE TABLE $tabelaConfiguracao (
          $colunaId INTEGER PRIMARY KEY,
          $colunaTema TEXT NOT NULL,
          $colunaIdioma TEXT NOT NULL
        )
      ''');

    await db.execute('''
        INSERT INTO $tabelaCategoria ($colunaNome)
          VALUES 
              ('Informática'),
              ('Roupa'),
              ('Comida'),
              ('Moveis')
      ''');

    await db.execute('''
        INSERT INTO $tabelaConfiguracao ($colunaTema, $colunaIdioma)
          VALUES 
              ('Light', 'Português')
      ''');
  }

  Future funcaoAtualizarBD(Database db, int oldVersion, int newVersion) async {
    //controle dos comandos sql para novas versões

    if (oldVersion < 2) {
      //Executa comandos
    }
  }

  Future funcaoDowngradeBD(Database db, int oldVersion, int newVersion) async {
    //controle dos comandos sql para voltar versãoes.
    //Estava-se na 2 e optou-se por regredir para a 1
  }

  Future<int> inserirProduto(Map<String, dynamic> row) async {
    await iniciarBD();
    return await _bancoDeDados.insert(tabelaProduto, row);
  }

  Future<List<Produto>> buscarProdutos(String pesquisa) async {
    await iniciarBD();

    List<Map<String, Object?>> produtosNoBanco = [];
    if (pesquisa.trim() != "") {
      produtosNoBanco = await _bancoDeDados.query(tabelaProduto,
          where: '$colunaNome LIKE ?', whereArgs: ['%$pesquisa%']);
    } else {
      produtosNoBanco = await _bancoDeDados.query(tabelaProduto);
    }

    return [
      for (final {
            colunaId: pId as int,
            colunaNome: pNome as String,
            colunaValor: pValor as double,
            colunaCategoria: pCategoria as String,
          } in produtosNoBanco)
        Produto(id: pId, nome: pNome, valor: pValor, categoria: pCategoria),
    ];
  }

  Future<void> editarProduto(Produto regProduto) async {
    await iniciarBD();

    await _bancoDeDados.update(
      tabelaProduto,
      regProduto.toMap(),
      where: '$colunaId = ?',
      whereArgs: [regProduto.id],
    );
  }

  Future<int> deleteProduto(int? id) async {
    await iniciarBD();
    return _bancoDeDados
        .delete(tabelaProduto, where: "$colunaId = ?", whereArgs: [id]);
  }

  Future<List<Categoria>> buscarCategorias() async {
    await iniciarBD();

    final List<Map<String, Object?>> categoriasNoBanco =
        await _bancoDeDados.query(tabelaCategoria);

    return [
      for (final {
            colunaId: pId as int,
            colunaNome: pNome as String,
          } in categoriasNoBanco)
        Categoria(id: pId, nome: pNome),
    ];
  }

  Future<void> editarConfiguracao(Configuracao config) async {
    await iniciarBD();

    await _bancoDeDados.update(tabelaConfiguracao, config.toMap(),
        where: '$colunaId = 1');
  }

  Future<Configuracao> buscarConfiguracao() async {
    await iniciarBD();

    final List<Map<String, Object?>> configuracao =
        await _bancoDeDados.query(tabelaConfiguracao);

    return [
      for (final {
            colunaId: pId as int,
            colunaIdioma: pIdioma as String,
            colunaTema: pTema as String,
          } in configuracao)
        Configuracao(id: pId, idioma: pIdioma, tema: pTema),
    ][0];
  }
}
