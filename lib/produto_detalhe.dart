import 'package:catalago_produto_flutter/bd/banco_helper.dart';
import 'package:catalago_produto_flutter/model/categoria.dart';
import 'package:catalago_produto_flutter/model/produto.dart';
import 'package:flutter/material.dart';

class ProdutoDetalhe extends StatefulWidget {
  ProdutoDetalhe({super.key, this.informacaoProduto});

  final Produto? informacaoProduto;

  @override
  State<ProdutoDetalhe> createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  var bdHelper = BancoHelper();
  final List<Produto> _dados = [];

  final List<Categoria> categorias = [];

  void carregarCategorias() async {
    var r = await bdHelper.buscarCategorias();
    setState(() {
      categorias.clear();
      categorias.addAll(r);
    });
    print(categorias);
  }

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerCategoria = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerValor.dispose();
    _controllerCategoria.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    carregarCategorias();
    if (widget.informacaoProduto != null) {
      _controllerNome.text = widget.informacaoProduto!.nome.toString();
      _controllerValor.text = widget.informacaoProduto!.valor.toString();
      _controllerCategoria.text =
          widget.informacaoProduto!.categoria.toString();
    } else {
      _controllerCategoria.text = "Informática";
    }
  }

  Future<void> editarRegistro(
      int idP, String nome, int valor, String categoria) async {
    final id = await bdHelper.editarProduto(
        Produto(id: idP, nome: nome, valor: valor, categoria: categoria));
  }

  Future<void> inserirRegistro(String nome, int valor, String categoria) async {
    Map<String, dynamic> row = {
      BancoHelper.colunaNome: nome,
      BancoHelper.colunaValor: valor,
      BancoHelper.colunaCategoria: categoria
    };

    final id = await bdHelper.inserirProduto(row);
  }

  Future<void> deletarRegistro() async {
    if (widget.informacaoProduto?.id != null) {
      final id = await bdHelper.deleteProduto(widget.informacaoProduto?.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Form(
      key: _formKey,
      child: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextFormField(
                initialValue: widget.informacaoProduto?.id.toString(),
                enabled: false,
                decoration: const InputDecoration(
                    labelText: 'Id',
                    border: OutlineInputBorder() //Gera a borda toda no campo.
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextFormField(
                controller: _controllerNome,
                decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder() //Gera a borda toda no campo.
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor preencha um valor para o campo nome.';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextFormField(
                controller: _controllerValor,
                decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder() //Gera a borda toda no campo.
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor preencha um valor para o campo valor.';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: DropdownButtonFormField<String>(
                value: _controllerCategoria.text, // Define o valor inicial
                decoration: const InputDecoration(
                  labelText: 'Select an option',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  _controllerCategoria.text = newValue ?? "";
                },
                items: <Categoria>[...categorias]
                    .map<DropdownMenuItem<String>>((Categoria value) {
                  return DropdownMenuItem<String>(
                    value: value.nome,
                    child: Text(value.nome ?? ""),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.informacaoProduto != null) {
                          editarRegistro(
                              widget.informacaoProduto!.id!,
                              _controllerNome.text,
                              int.parse(_controllerValor.text),
                              _controllerCategoria.text);
                        } else {
                          inserirRegistro(
                              _controllerNome.text,
                              int.parse(_controllerValor.text),
                              _controllerCategoria.text);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('salvar'),
                  ),
                  widget.informacaoProduto != null
                      ? ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              deletarRegistro();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('deletar'),
                        )
                      : const Text("")
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
