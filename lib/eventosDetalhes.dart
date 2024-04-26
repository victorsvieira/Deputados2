import 'package:deputados/eventosDetalhesDeputados.dart';
import 'package:deputados/eventosDetalhesOrgaos.dart';
import 'package:deputados/eventosDetalhesPauta.dart';
import 'package:deputados/eventosDetalhesVotacoes.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EventoDetalhes extends StatefulWidget {
  final int eventoId;

  const EventoDetalhes({super.key, required this.eventoId});

  @override
  State<EventoDetalhes> createState() => _EventoDetalhesState();
}

class _EventoDetalhesState extends State<EventoDetalhes> {
  late Map<String, dynamic> eventoDetalhes = {};

  Future<void> fetchEventoDetalhes(int id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/eventos/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventoDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventoDetalhes(widget.eventoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Evento'),
        ),
        body: eventoDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '\nTIPO: ${eventoDetalhes['descricaoTipo'] ?? 'nada'}'),
                        Text(
                            '\nDESCRIÇÃO: ${eventoDetalhes['descricao'] ?? 'nada'}'),
                        const Divider(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventosDetalhesDeputados(
                                          deputadoId:
                                              eventoDetalhes['id'].toString()),
                                ),
                              );
                            },
                            child: const Text("Deputados do evento")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventosDetalhesOrgaos(
                                      deputadoId:
                                          eventoDetalhes['id'].toString()),
                                ),
                              );
                            },
                            child: const Text("Órgãos do evento")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventosDetalhesPauta(
                                      deputadoId:
                                          eventoDetalhes['id'].toString()),
                                ),
                              );
                            },
                            child: const Text("Pauta do evento")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventosDetalhesVotacoes(
                                      deputadoId:
                                          eventoDetalhes['id'].toString()),
                                ),
                              );
                            },
                            child: const Text("Votações do evento")),
                      ]),
                ),
              ));
  }
}
