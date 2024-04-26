import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'OrgaosDetalhes.dart';

class Proposicoes extends StatefulWidget {
  const Proposicoes({super.key});

  @override
  State<Proposicoes> createState() => _ProposicoesState();
}

class _ProposicoesState extends State<Proposicoes> {
  late List<dynamic> proposicoes = [];

  Future<void> fetchProposicoes() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/proposicoes?ordem=ASC&ordenarPor=id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          proposicoes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProposicoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposições"),
      ),
      body: proposicoes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: proposicoes.length,
              itemBuilder: (context, index) {
                final proposicao = proposicoes[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(proposicao['siglaTipo'].toString()),
                    trailing: Text(proposicao['ano'].toString()),

                    subtitle: Text(proposicao['ementa'].toString()),

                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         OrgaoDetalhes(proposicaoId: proposicao['id']),
                      //   ),
                      // );
                      // Adicione aqui a ação ao clicar no proposicao, se necessário
                    },
                    // Outros detalhes ou ações que deseja adicionar para cada proposicao
                  ),
                );
              },
            ),
    );
  }
}
