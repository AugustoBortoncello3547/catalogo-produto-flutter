import 'package:catalago_produto_flutter/bd/banco_helper.dart';
import 'package:catalago_produto_flutter/model/configuracao.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:catalago_produto_flutter/model/configuracao.dart';
import 'package:flutter/material.dart';

const idiomasPermitidos = ["Português", "Inglês"];
const temasPermitidos = ["Light", "Dark"];

class ConfiguracaoDetalhe extends StatefulWidget {
  const ConfiguracaoDetalhe({super.key});

  @override
  _ConfiguracaoDetalheState createState() => _ConfiguracaoDetalheState();
}

class _ConfiguracaoDetalheState extends State<ConfiguracaoDetalhe> {
  final bdHelper = BancoHelper();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerTema = TextEditingController();
  final TextEditingController _controllerIdioma = TextEditingController();

  @override
  void initState() {
    super.initState();
    buscarConfiguracao();
  }

  void buscarConfiguracao() async {
    final response = await bdHelper.buscarConfiguracao();

    setState(() {
      _controllerTema.text = response.tema ?? temasPermitidos.first;
      _controllerIdioma.text = response.idioma ?? idiomasPermitidos.first;
    });
  }

  Future<void> editarConfiguracao(String temaC, String idiomaC) async {
    await bdHelper
        .editarConfiguracao(Configuracao(id: 1, idioma: idiomaC, tema: temaC));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _controllerTema.text.isNotEmpty
                    ? _controllerTema.text
                    : temasPermitidos.first,
                decoration: const InputDecoration(
                  labelText: 'Tema',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  _controllerTema.text = newValue ?? "";
                },
                items: temasPermitidos
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _controllerIdioma.text.isNotEmpty
                    ? _controllerIdioma.text
                    : idiomasPermitidos.first,
                decoration: const InputDecoration(
                  labelText: 'Idioma',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  _controllerIdioma.text = newValue ?? "";
                },
                items: idiomasPermitidos
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        editarConfiguracao(
                            _controllerTema.text, _controllerIdioma.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Salvar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Voltar"),
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
