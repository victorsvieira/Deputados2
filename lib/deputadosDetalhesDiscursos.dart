import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeputadosDetalhesDiscursos extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesDiscursos({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesDiscursos> createState() =>
      _DeputadosDetalhesDiscursosState();
}

class _DeputadosDetalhesDiscursosState
    extends State<DeputadosDetalhesDiscursos> {
  late List<dynamic> discursosDetalhes = [];

  Future<void> fetchDiscursosDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/discursos?ordenarPor=dataHoraInicio&ordem=ASC'));
    print(id);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          discursosDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiscursosDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discursos do Parlamentar"),
      ),
      body: discursosDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: discursosDetalhes.map((discurso) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(discurso['dataHoraInicio'].toString()),
                        Text(discurso['faseEvento']['titulo'].toString()),
                        Text(discurso['tipoDiscurso'].toString()),
                        Text(discurso['urlTexto'].toString()),
                        Text(discurso['transcricao'].toString()),
                        const Divider(), // Adiciona uma linha divisória entre discursos
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
