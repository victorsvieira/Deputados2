import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'LegislaturasDetalhesLideres.dart';

class Legislaturas extends StatefulWidget {
  const Legislaturas({super.key});

  @override
  State<Legislaturas> createState() => _LegislaturasState();
}

class _LegislaturasState extends State<Legislaturas> {
  late List<dynamic> legislaturas = [];

  Future<void> fetchLegislaturas() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/legislaturas?ordem=DESC&ordenarPor=id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          legislaturas = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLegislaturas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legislaturas parlamentares"),
      ),
      body: legislaturas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: legislaturas.length,
              itemBuilder: (context, index) {
                final legislatura = legislaturas[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                        "Início: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(legislatura['dataInicio']))}"),
                    subtitle: Text(
                        "Fim: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(legislatura['dataFim']))}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LegislaturasDetalhesLideres(
                              legislaturaId: legislatura['id']),
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
