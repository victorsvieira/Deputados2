import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FrenteDetalhesMembros extends StatefulWidget {
  final int frenteId;

  const FrenteDetalhesMembros({super.key, required this.frenteId});

  @override
  State<FrenteDetalhesMembros> createState() => _FrenteDetalhesMembrosState();
}

class _FrenteDetalhesMembrosState extends State<FrenteDetalhesMembros> {
  late List<dynamic> frenteDetalhesMembros = [];

  Future<void> fetchFrenteDetalhesMembros(int id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/frentes/$id/membros'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          frenteDetalhesMembros = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFrenteDetalhesMembros(widget.frenteId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membros da Frente'),
      ),
      body: frenteDetalhesMembros.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: frenteDetalhesMembros.length,
                itemBuilder: (context, index) {
                  final FrenteDetalhesMembros = frenteDetalhesMembros[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      minLeadingWidth: 100,
                      title: Text(FrenteDetalhesMembros['nome'].toString()),

                      leading: Text(
                          FrenteDetalhesMembros['siglaPartido'].toString()),

                      // Outros detalhes ou ações que deseja adicionar para cada frente
                    ),
                  );
                },
              ),
            ),
    );
  }
}
