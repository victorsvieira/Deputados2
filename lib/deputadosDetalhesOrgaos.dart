import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class DeputadosDetalhesOrgaos extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesOrgaos({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesOrgaos> createState() =>
      _DeputadosDetalhesOrgaosState();
}

class _DeputadosDetalhesOrgaosState extends State<DeputadosDetalhesOrgaos> {
  late List<dynamic> orgaosDetalhes = [];

  Future<void> fetchOrgaosDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/orgaos?ordem=ASC&ordenarPor=dataInicio'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          orgaosDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrgaosDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Órgãos do Parlamentar"),
      ),
      body: orgaosDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: orgaosDetalhes.map((orgao) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${orgao['siglaOrgao']} - ${orgao['nomeOrgao']}\n",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text("${orgao['nomePublicacao']}"),
                        Text("${orgao['titulo']}"),

                        if (orgao['dataInicio'] != null)
                          Text(
                            DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(orgao['dataInicio']),
                            ),
                          ),

                        // Outros detalhes ou ações que deseja adicionar para cada frente

                        const Divider(), // Adiciona uma linha divisória entre eventos
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
