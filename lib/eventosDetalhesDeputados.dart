import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosDetalhesDeputados extends StatefulWidget {
  final String deputadoId;

  const EventosDetalhesDeputados({super.key, required this.deputadoId});

  @override
  State<EventosDetalhesDeputados> createState() =>
      _EventosDetalhesDeputadosState();
}

class _EventosDetalhesDeputadosState extends State<EventosDetalhesDeputados> {
  late List<dynamic> eventosDeputados = [];

  Future<void> fetchEventosDeputados(String id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/eventos/$id/deputados'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventosDeputados = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventosDeputados(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deputados do evento"),
      ),
      body: eventosDeputados.isEmpty
          ? Center(
              child: eventosDeputados.isNotEmpty
                  ? CircularProgressIndicator()
                  : Text("Não há informações"),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventosDeputados.map((eventoDeputado) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventoDeputado['nome'].toString()),
                        Text(eventoDeputado['siglaPartido'].toString()),
                        Text(eventoDeputado['siglaUf'].toString()),
                        Text(eventoDeputado['urlFoto'].toString()),
                        Text(eventoDeputado['email'].toString()),

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
