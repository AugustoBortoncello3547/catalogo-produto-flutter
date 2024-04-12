import 'package:catalago_produto_flutter/bd/banco_helper.dart';
import 'package:catalago_produto_flutter/model/produto.dart';
import 'package:catalago_produto_flutter/produto_detalhe.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final bdHelper = BancoHelper();
  final List<Produto> _dados = [];

  void carregarProdutosSalvas() async {
    final r = await bdHelper.buscarProdutos();

    setState(() {
      _dados.clear();
      _dados.addAll(r);
    });
  }

  @override
  void initState() {
    super.initState();
    carregarProdutosSalvas();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo de Produtos'), // Alteração do título
        ),
        body: SafeArea(
          child: Center(
            child: _dados.isEmpty
                ? const Text('Nenhum produto disponível')
                : ListView.builder(
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      final produto = _dados[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.info_outline),
                          trailing: Text(
                            'R\$ ${produto.valor ?? 'Não informado'}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          title: Text(produto.nome ?? 'Nome não informado'),
                          onTap: () async {
                            final param = _dados[index];
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProdutoDetalhe(
                                  informacaoProduto: param,
                                ),
                              ),
                            );
                            carregarProdutosSalvas();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.playlist_add),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProdutoDetalhe(informacaoProduto: null)));

                carregarProdutosSalvas();
              },
            );
          },
        ),
      ),
    );
  }
}
