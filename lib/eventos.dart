import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'eventosDetalhes.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  late List<dynamic> eventos = [];

  Future<void> fetchEventos() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/eventos?ordem=ASC&ordenarPor=dataHoraInicio'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventos = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
      ),
      body: eventos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(evento['descricaoTipo'].toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(evento['orgaos'][0]['nomeResumido'] ?? 'nada'),
                        Text(
                          '${evento['orgaos'][0]['nome']} - ${evento['orgaos'][0]['sigla']}',
                        ),
                      ],
                    ),
                    trailing: Text(evento['situacao'].toString()),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventoDetalhes(eventoId: evento['id']),
                        ),
                      );

                      // Adicione aqui a ação ao clicar no evento, se necessário
                    },
                    // Outros detalhes ou ações que deseja adicionar para cada evento
                  ),
                );
              },
            ),
    );
  }
}
