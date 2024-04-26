import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'frentesDetalhesMembros.dart';

class FrenteDetalhes extends StatefulWidget {
  final int frenteId;

  const FrenteDetalhes({super.key, required this.frenteId});

  @override
  State<FrenteDetalhes> createState() => _FrenteDetalhesState();
}

class _FrenteDetalhesState extends State<FrenteDetalhes> {
  late Map<String, dynamic> frenteDetalhes = {};

  Future<void> fetchFrenteDetalhes(int id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/frentes/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          frenteDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFrenteDetalhes(widget.frenteId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Frente'),
        ),
        body: frenteDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Título: ${frenteDetalhes['titulo'] ?? 'nada'}'),
                        Text(
                            '\nCoordenador: ${frenteDetalhes['coordenador']['nome'] ?? 'nada'}'),
                        Text(
                          '\nSituação: ${frenteDetalhes['situacao'] ?? 'nada'}\n',
                          textAlign: TextAlign.justify,
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FrenteDetalhesMembros(
                                      frenteId: widget.frenteId),
                                ),
                              );
                            }),
                            child: const Text("Membros")),
                      ]),
                ),
              ));
  }
}
