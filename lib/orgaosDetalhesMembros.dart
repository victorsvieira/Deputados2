import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrgaoDetalhesMembros extends StatefulWidget {
  final int orgaoId;

  const OrgaoDetalhesMembros({super.key, required this.orgaoId});

  @override
  State<OrgaoDetalhesMembros> createState() => _OrgaoDetalhesMembrosState();
}

class _OrgaoDetalhesMembrosState extends State<OrgaoDetalhesMembros> {
  late List<dynamic> orgaoDetalhesMembros = [];

  Future<void> fetchOrgaoDetalhesMembros(int id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/orgaos/$id/membros'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          orgaoDetalhesMembros = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrgaoDetalhesMembros(widget.orgaoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membros do Órgão'),
      ),
      body: orgaoDetalhesMembros.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: orgaoDetalhesMembros.length,
                itemBuilder: (context, index) {
                  final orgaoDetalhesMembrosLista = orgaoDetalhesMembros[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      minLeadingWidth: 100,
                      title: Text(orgaoDetalhesMembrosLista['nome'].toString()),

                      leading: Text(
                          orgaoDetalhesMembrosLista['siglaPartido'].toString()),

                      // Outros detalhes ou ações que deseja adicionar para cada frente
                    ),
                  );
                },
              ),
            ),
    );
  }
}
