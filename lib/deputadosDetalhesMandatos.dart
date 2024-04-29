import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeputadosDetalhesMandatos extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesMandatos({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesMandatos> createState() =>
      _DeputadosDetalhesMandatosState();
}

class _DeputadosDetalhesMandatosState extends State<DeputadosDetalhesMandatos> {
  late List<dynamic> mandatosDetalhes = [];

  Future<void> fetchMandatosDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/mandatosExternos'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          mandatosDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMandatosDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mandatos externos do Parlamentar"),
      ),
      body: mandatosDetalhes.isEmpty
          ? Center(
              child: mandatosDetalhes.isNotEmpty
                  ? CircularProgressIndicator()
                  : Text("Não há informações"),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mandatosDetalhes.map((mandato) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Cargo: ${mandato['cargo']}, ${mandato['municipio']} - ${mandato['siglaUf']}"),

                        Text(
                            "Início em ${mandato['anoInicio']} até ${mandato['anoFim']}"),

                        Text(
                            "Partido de eleição: ${mandato['siglaPartidoEleicao']}"),

                        // Outros detalhes ou ações que deseja adicionar para cada frente

                        const Divider(), // Adiciona uma linha divisória entre eventos
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
