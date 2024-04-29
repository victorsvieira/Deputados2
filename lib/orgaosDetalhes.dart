import 'package:deputados/orgaosDetalhesMembros.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrgaosDetalhes extends StatefulWidget {
  final int orgaoId;

  const OrgaosDetalhes({super.key, required this.orgaoId});

  @override
  State<OrgaosDetalhes> createState() => _OrgaosDetalhesState();
}

class _OrgaosDetalhesState extends State<OrgaosDetalhes> {
  late Map<String, dynamic> OrgaosDetalhes = {};

  Future<void> fetchOrgaosDetalhes(int id) async {
    final response = await http
        .get(Uri.parse('https://dadosabertos.camara.leg.br/api/v2/orgaos/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          OrgaosDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrgaosDetalhes(widget.orgaoId);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Órgão'),
        ),
        body: OrgaosDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${OrgaosDetalhes['sigla'] ?? 'Sem informações'} - ${OrgaosDetalhes['nome'] ?? 'Sem informações'}\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          'Apelido: ${OrgaosDetalhes['apelido'] ?? 'Sem informações'}',
                        ),
                        Text(
                          'Tipo de órgão: ${OrgaosDetalhes['tipoOrgao'] ?? 'Sem informações'}',
                        ),
                        Text(
                          'Nome de publicação: ${OrgaosDetalhes['nomePublicacao'] ?? 'Sem informações'}',
                        ),
                        Text(
                          'Sala: ${OrgaosDetalhes['sala'] ?? 'Sem informações'}\n',
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgaoDetalhesMembros(
                                      orgaoId: widget.orgaoId),
                                ),
                              );
                            }),
                            child: const Text("Membros")),
                      ]),
                ),
              ));
  }
}
