import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'votacoesDetalhes.dart';

import 'votacoesDetalhes.dart';
// import 'OrgaosDetalhes.dart';

class Votacoes extends StatefulWidget {
  const Votacoes({Key? key}) : super(key: key);

  @override
  State<Votacoes> createState() => _VotacoesState();
}

class _VotacoesState extends State<Votacoes> {
  late List<dynamic> votacoes = [];

  Future<void> fetchVotacoes() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/votacoes?ordem=DESC&ordenarPor=dataHoraRegistro'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          votacoes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votações"),
      ),
      body: votacoes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: votacoes.length + 1, // +1 para o item adicional
              itemBuilder: (context, index) {
                final itemVotacao = votacoes[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                      title: Text(itemVotacao['siglaOrgao'].toString()),
                      subtitle: Text(
                          'Descrição: ${itemVotacao['descricao'].toString()}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VotacoesDetalhes(votacaoId: itemVotacao['id']),
                          ),
                        );
                      }),
                );
              },
            ),
    );
  }
}
