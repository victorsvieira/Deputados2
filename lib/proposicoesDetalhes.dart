import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'frentesDetalhesMembros.dart';

class ProposicoesDetalhes extends StatefulWidget {
  final int proposicaoId;

  const ProposicoesDetalhes({super.key, required this.proposicaoId});

  @override
  State<ProposicoesDetalhes> createState() => _ProposicoesDetalhesState();
}

class _ProposicoesDetalhesState extends State<ProposicoesDetalhes> {
  late Map<String, dynamic> proposicoesDetalhes = {};

  Future<void> fetchProposicoesDetalhes(int id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/proposicoes/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          proposicoesDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProposicoesDetalhes(widget.proposicaoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Partido'),
        ),
        body: proposicoesDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ementa: ${proposicoesDetalhes['ementa']}\n',
                        ),
                        Text(
                          'Data: ${proposicoesDetalhes['statusProposicao']['dataHora']}\n',
                        ),
                        Text(
                          'Tramitação: ${proposicoesDetalhes['statusProposicao']['descricaoTramitacao']}\n',
                        ),
                        Text(
                          'Situação: ${proposicoesDetalhes['statusProposicao']['descricaoSituacao']}\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Despacho: ${proposicoesDetalhes['statusProposicao']['despacho']}\n',
                        ),
                        Text(
                          'Apreciação: ${proposicoesDetalhes['statusProposicao']['apreciacao']}\n',
                        ),
                        Text(
                          'Ementa: ${proposicoesDetalhes['statusProposicao']['descricaoSituacao']}\n',
                        ),
                      ]),
                ),
              ));
  }
}
