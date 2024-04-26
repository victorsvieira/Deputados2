import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'frentesDetalhes.dart';

class DeputadosDetalhesFrentes extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesFrentes({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesFrentes> createState() =>
      _DeputadosDetalhesFrentesState();
}

class _DeputadosDetalhesFrentesState extends State<DeputadosDetalhesFrentes> {
  late List<dynamic> frentesDetalhes = [];

  Future<void> fetcheFrentesDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/frentes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          frentesDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetcheFrentesDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frentes do Parlamentar"),
      ),
      body: frentesDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: frentesDetalhes.map((frente) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(frente['titulo'].toString()),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FrenteDetalhes(frenteId: frente['id']),
                              ),
                            );
                            // Adicione aqui a ação ao clicar no frente, se necessário
                          },
                          // Outros detalhes ou ações que deseja adicionar para cada frente
                        ),
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
