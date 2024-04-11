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
  var bdHelper = BancoHelper();
  final List<Produto> _dados = [];

  void carregarProdutosSalvas() async {
    var r = await bdHelper.buscarProdutos();

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Produtos'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dados[index].nome ?? 'Nome não informado'),
                        //Função do click/Toque
                        onTap: () async {
                          var param = _dados[index];

                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProdutoDetalhe(
                                      informacaoProduto: param)));

                          carregarProdutosSalvas();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        /*Utilizado o Builder para facilitar depois a navegação entre telas */
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.person_add),
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
