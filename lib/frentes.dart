import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'frentesDetalhes.dart';

class Frentes extends StatefulWidget {
  const Frentes({super.key});

  @override
  State<Frentes> createState() => _FrentesState();
}

class _FrentesState extends State<Frentes> {
  late List<dynamic> Frentes = [];

  Future<void> fetchFrentes() async {
    final response = await http
        .get(Uri.parse('https://dadosabertos.camara.leg.br/api/v2/frentes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          Frentes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFrentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frentes Parlamentares"),
      ),
      body: Frentes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: Frentes.length,
              itemBuilder: (context, index) {
                final frente = Frentes[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(frente['titulo'].toString()),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FrenteDetalhes(frenteId: frente['id']),
                        ),
                      );
                      // Adicione aqui a ação ao clicar no frente, se necessário
                    },
                    // Outros detalhes ou ações que deseja adicionar para cada frente
                  ),
                );
              },
            ),
    );
  }
}
