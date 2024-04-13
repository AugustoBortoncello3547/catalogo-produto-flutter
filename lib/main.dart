import 'package:catalago_produto_flutter/bd/banco_helper.dart';
import 'package:catalago_produto_flutter/configuracao_detalhe.dart';
import 'package:catalago_produto_flutter/model/produto.dart';
import 'package:catalago_produto_flutter/produto_detalhe.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

NumberFormat formatoBrasileiro =
    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final bdHelper = BancoHelper();
  final List<Produto> _dados = [];

  void carregarProdutosSalvos([pesquisa]) async {
    final r = await bdHelper.buscarProdutos(pesquisa ?? "");

    setState(() {
      _dados.clear();
      _dados.addAll(r);
    });
  }

  @override
  void initState() {
    super.initState();
    carregarProdutosSalvos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            actions: [
              Builder(
                builder: (context) => Center(
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Abrir configurações',
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ConfiguracaoDetalhe()));

                      carregarProdutosSalvos();
                    },
                  ),
                ),
              ),
            ],
            title: const Text('Catálogo de Produtos'), // Alteração do título
          ),
          body: SafeArea(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar produto...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    carregarProdutosSalvos(value);
                  },
                ),
                Expanded(
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
                                    formatoBrasileiro.format(produto.valor) ??
                                        "Valor não informado",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  title: Text(
                                      produto.nome ?? 'Nome não informado'),
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
                                    carregarProdutosSalvos();
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
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

                  carregarProdutosSalvos();
                },
              );
            },
          )),
    );
  }
}
