import 'package:deputados/legislaturasDetalhesMesa.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LegislaturasDetalhesLideres extends StatefulWidget {
  final int legislaturaId;

  const LegislaturasDetalhesLideres({super.key, required this.legislaturaId});

  @override
  State<LegislaturasDetalhesLideres> createState() =>
      _LegislaturasDetalhesLideresState();
}

class _LegislaturasDetalhesLideresState
    extends State<LegislaturasDetalhesLideres> {
  late List<dynamic> lideresDetalhes = [];

  Future<void> fetchLideresDetalhes(int id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/legislaturas/$id/lideres'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          lideresDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLideresDetalhes(widget.legislaturaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Líderes da legislatura"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LegislaturasDetalhesMesa(
                        legislaturaId: widget.legislaturaId),
                  ),
                );
              },
              child: const Text("Mesas")),
        ],
      ),
      body: lideresDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lideresDetalhes.map((lideresLegislatura) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lideresLegislatura['parlamentar']['nome']
                            .toString()),
                        Text(lideresLegislatura['parlamentar']['siglaPartido']
                            .toString()),
                        Text(lideresLegislatura['parlamentar']['siglaUf']
                            .toString()),
                        Text(lideresLegislatura['parlamentar']['email']
                            .toString()),
                        Text(lideresLegislatura['parlamentar']['urlFoto']
                            .toString()),
                        Text(lideresLegislatura['titulo'].toString()),
                        Text(lideresLegislatura['bancada']['tipo'].toString()),
                        Text(lideresLegislatura['dataInicio'].toString()),

                        const Divider(), // Adiciona uma linha divisória entre despesas
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
