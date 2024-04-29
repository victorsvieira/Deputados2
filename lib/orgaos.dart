import 'package:flutter/material.dart';
import 'orgaosDetalhes.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'OrgaosDetalhes.dart';

class Orgaos extends StatefulWidget {
  const Orgaos({super.key});

  @override
  State<Orgaos> createState() => _OrgaosState();
}

class _OrgaosState extends State<Orgaos> {
  late List<dynamic> orgaos = [];

  Future<void> fetchOrgaos() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/orgaos?ordem=ASC&ordenarPor=id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          orgaos = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrgaos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Órgãos"),
      ),
      body: orgaos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orgaos.length,
              itemBuilder: (context, index) {
                final orgao = orgaos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(orgao['sigla'].toString()),
                    subtitle: Text(orgao['nome'].toString()),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrgaosDetalhes(orgaoId: orgao['id']),
                        ),
                      );
                    },
                    // Outros detalhes ou ações que deseja adicionar para cada orgao
                  ),
                );
              },
            ),
    );
  }
}
