import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosDetalhesOrgaos extends StatefulWidget {
  final String deputadoId;

  const EventosDetalhesOrgaos({super.key, required this.deputadoId});

  @override
  State<EventosDetalhesOrgaos> createState() => _EventosDetalhesOrgaosState();
}

class _EventosDetalhesOrgaosState extends State<EventosDetalhesOrgaos> {
  late List<dynamic> eventosOrgaos = [];

  Future<void> fetchEventosOrgaos(String id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/eventos/$id/orgaos'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventosOrgaos = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventosOrgaos(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Órgãos do evento"),
      ),
      body: eventosOrgaos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventosOrgaos.map((eventoOrgao) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventoOrgao['sigla'].toString()),
                        Text(eventoOrgao['nome'].toString()),
                        Text(eventoOrgao['apelido'].toString()),
                        Text(eventoOrgao['tipoOrgao'].toString()),

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
