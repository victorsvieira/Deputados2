import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosDetalhesVotacoes extends StatefulWidget {
  final String deputadoId;

  const EventosDetalhesVotacoes({super.key, required this.deputadoId});

  @override
  State<EventosDetalhesVotacoes> createState() =>
      _EventosDetalhesVotacoesState();
}

class _EventosDetalhesVotacoesState extends State<EventosDetalhesVotacoes> {
  late List<dynamic> eventosVotacoes = [];

  Future<void> fetchEventosVotacoes(String id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/eventos/$id/votacoes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventosVotacoes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventosVotacoes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votações do evento"),
      ),
      body: eventosVotacoes.isEmpty
          ? Center(
              child: eventosVotacoes.isNotEmpty
                  ? CircularProgressIndicator()
                  : Text("Não há informações"),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventosVotacoes.map((eventoVotacao) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventoVotacao['data'].toString()),
                        Text(eventoVotacao['siglaOrgao'].toString()),

                        Text(eventoVotacao['descricao'].toString()),

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
