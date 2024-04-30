import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'frentesDetalhesMembros.dart';

class PartidoDetalhes extends StatefulWidget {
  final int partidopoliticoId;

  const PartidoDetalhes({super.key, required this.partidopoliticoId});

  @override
  State<PartidoDetalhes> createState() => _PartidoDetalhesState();
}

class _PartidoDetalhesState extends State<PartidoDetalhes> {
  late Map<String, dynamic> partidoDetalhes = {};

  Future<void> fetchPartidoDetalhes(int id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/partidos/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          partidoDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPartidoDetalhes(widget.partidopoliticoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Partido'),
        ),
        body: partidoDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${partidoDetalhes['sigla']} - ${partidoDetalhes['nome']} (${partidoDetalhes['status']['situacao']})\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                            'Total de membros: ${partidoDetalhes['status']['totalMembros']}'),
                        Text(
                            'Líder: ${partidoDetalhes['status']['lider']['nome']} - ${partidoDetalhes['status']['lider']['siglaPartido']} (${partidoDetalhes['status']['lider']['uf']})'),
                      ]),
                ),
              ));
  }
}
