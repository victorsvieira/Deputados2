import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'PartidosDetalhesLideres.dart';
import 'partidosDetalhes.dart';

class Partidos extends StatefulWidget {
  const Partidos({super.key});

  @override
  State<Partidos> createState() => _PartidosState();
}

class _PartidosState extends State<Partidos> {
  late List<dynamic> partidos = [];

  Future<void> fetchPartidos() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/partidos?ordem=ASC&ordenarPor=sigla'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          partidos = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPartidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partidos Políticos"),
      ),
      body: partidos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: partidos.length,
              itemBuilder: (context, index) {
                final partidopolitico = partidos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "${partidopolitico['sigla']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${partidopolitico['nome']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartidoDetalhes(
                              partidopoliticoId: partidopolitico['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
