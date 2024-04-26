import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LegislaturasDetalhesMesa extends StatefulWidget {
  final int legislaturaId;

  const LegislaturasDetalhesMesa({super.key, required this.legislaturaId});

  @override
  State<LegislaturasDetalhesMesa> createState() =>
      _LegislaturasDetalhesMesaState();
}

class _LegislaturasDetalhesMesaState extends State<LegislaturasDetalhesMesa> {
  late List<dynamic> mesaDetalhes = [];

  Future<void> fetchMesaDetalhes(int id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/legislaturas/$id/mesa'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          mesaDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMesaDetalhes(widget.legislaturaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesa da legislatura"),
      ),
      body: mesaDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mesaDetalhes.map((mesaLegislatura) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mesaLegislatura['titulo'].toString()),
                        Text(mesaLegislatura['nome'].toString()),
                        Text(mesaLegislatura['siglaPartido'].toString()),
                        Text(mesaLegislatura['siglaUf'].toString()),
                        Text(mesaLegislatura['dataInicio'].toString()),
                        const Divider(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
