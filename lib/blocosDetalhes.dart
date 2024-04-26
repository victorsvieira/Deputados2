import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class BlocosDetalhes extends StatefulWidget {
  final String blocoId;

  const BlocosDetalhes({super.key, required this.blocoId});

  @override
  State<BlocosDetalhes> createState() => _BlocosDetalhesState();
}

class _BlocosDetalhesState extends State<BlocosDetalhes> {
  late Map<String, dynamic> blocoDetalhes = {};

  Future<void> fetchBlocosDetalhes(String id) async {
    final response = await http
        .get(Uri.parse('https://dadosabertos.camara.leg.br/api/v2/blocos/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          blocoDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlocosDetalhes(widget.blocoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Bloco'),
        ),
        body: blocoDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\nNome: ${blocoDetalhes['nome'] ?? 'nada'}'),
                      Text(
                          '\nDESCRIÇÃO: ${blocoDetalhes['descricao'] ?? 'nada'}'),
                    ]),
              ));
  }
}
