import 'package:catalago_produto_flutter/bd/banco_helper.dart';
import 'package:catalago_produto_flutter/model/categoria.dart';
import 'package:catalago_produto_flutter/model/produto.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class ProdutoDetalhe extends StatefulWidget {
  const ProdutoDetalhe({super.key, this.informacaoProduto});

  final Produto? informacaoProduto;

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  final bdHelper = BancoHelper();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerCategoria = TextEditingController();

  late List<Categoria> categorias;

  @override
  void initState() {
    super.initState();
    categorias = [];
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

  void carregarCategorias() async {
    final r = await bdHelper.buscarCategorias();
    setState(() {
      categorias.addAll(r);
    });
  }

  Future<void> editarRegistro(
      int idP, String nome, double valor, String categoria) async {
    await bdHelper.editarProduto(
        Produto(id: idP, nome: nome, valor: valor, categoria: categoria));
  }

  Future<void> inserirRegistro(
      String nome, double valor, String categoria) async {
    final row = {
      BancoHelper.colunaNome: nome,
      BancoHelper.colunaValor: valor,
      BancoHelper.colunaCategoria: categoria
    };

    await bdHelper.inserirProduto(row);
  }

  Future<void> deletarRegistro() async {
    if (widget.informacaoProduto?.id != null) {
      await bdHelper.deleteProduto(widget.informacaoProduto?.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.informacaoProduto != null
            ? 'Editar Produto'
            : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.informacaoProduto != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'ID: ${widget.informacaoProduto!.id}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              TextFormField(
                controller: _controllerNome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor preencha um valor para o campo nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _controllerValor,
                inputFormatters: [
                  CurrencyTextInputFormatter(locale: "pt_br", symbol: '')
                ],
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor preencha um valor para o campo valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _controllerCategoria.text,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  _controllerCategoria.text = newValue ?? "";
                },
                items:
                    categorias.map<DropdownMenuItem<String>>((Categoria value) {
                  return DropdownMenuItem<String>(
                    value: value.nome,
                    child: Text(value.nome ?? ""),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.informacaoProduto != null)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          deletarRegistro();
                          Navigator.pop(context);
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Deletar',
                        style: TextStyle(
                          color: Colors.white, // Definindo a cor do texto como branco
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.informacaoProduto != null) {
                          editarRegistro(
                              widget.informacaoProduto!.id!,
                              _controllerNome.text,
                              double.parse(
                                  _controllerValor.text.replaceAll(',', '.')),
                              _controllerCategoria.text);
                        } else {
                          inserirRegistro(
                              _controllerNome.text,
                              double.parse(
                                  _controllerValor.text.replaceAll(',', '.')),
                              _controllerCategoria.text);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.informacaoProduto != null
                        ? 'Atualizar'
                        : 'Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
