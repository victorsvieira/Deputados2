import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosDetalhesPauta extends StatefulWidget {
  final String deputadoId;

  const EventosDetalhesPauta({super.key, required this.deputadoId});

  @override
  State<EventosDetalhesPauta> createState() => _EventosDetalhesPautaState();
}

class _EventosDetalhesPautaState extends State<EventosDetalhesPauta> {
  late List<dynamic> eventosPauta = [];

  Future<void> fetchEventosPauta(String id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/eventos/$id/pauta'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventosPauta = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventosPauta(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pauta do evento"),
      ),
      body: eventosPauta.isEmpty
          ? Center(
              child: eventosPauta.isNotEmpty
                  ? CircularProgressIndicator()
                  : Text("Não há informações"),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventosPauta.map((eventoPauta) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventoPauta['topico'].toString()),
                        Text(eventoPauta['regime'].toString()),
                        Text(eventoPauta['titulo'].toString()),
                        Text(
                            eventoPauta['proposicao_']['siglaTipo'].toString()),
                        Text(eventoPauta['proposicao_']['ano'].toString()),
                        Text(eventoPauta['proposicao_']['ementa'].toString()),
                        Text(eventoPauta['relator'].toString()),
                        Text(eventoPauta['textoParecer'].toString()),
                        Text(eventoPauta['uriVotacao'].toString()),
                        Text(eventoPauta['situacaoItem'].toString()),

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
