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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mandatosDetalhes.map((mandato) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mandato['cargo'].toString()),
                        Text(mandato['siglaUf'].toString()),
                        Text(mandato['municipio'].toString()),
                        Text(mandato['anoInicio'].toString()),
                        Text(mandato['anoFim'].toString()),
                        Text(mandato['siglaPartidoEleicao'].toString()),
                        Text(mandato['uriPartidoEleicao'].toString()),

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
