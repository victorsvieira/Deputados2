import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'frentesDetalhesMembros.dart';

class VotacoesDetalhes extends StatefulWidget {
  final String votacaoId;

  const VotacoesDetalhes({super.key, required this.votacaoId});

  @override
  State<VotacoesDetalhes> createState() => _VotacoesDetalhesState();
}

class _VotacoesDetalhesState extends State<VotacoesDetalhes> {
  late Map<String, dynamic> votacoesDetalhes = {};

  Future<void> fetchVotacoesDetalhes(String id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/votacoes/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          votacoesDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVotacoesDetalhes(widget.votacaoId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Votação'),
        ),
        body: votacoesDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sigla: ${votacoesDetalhes['siglaOrgao']}\n',
                        ),
                        Text(
                          'Descrição: ${votacoesDetalhes['descricao']}\n',
                        ),
                        Text(
                          'Mais detalhes: ${votacoesDetalhes['ultimaApresentacaoProposicao']['descricao']}\n',
                        ),
                        Text(
                          'Ementa: ${votacoesDetalhes['proposicoesAfetadas'][0]['ementa']}\n',
                        ),
                      ]),
                ),
              ));
  }
}
