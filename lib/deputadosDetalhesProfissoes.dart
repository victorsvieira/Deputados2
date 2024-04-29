import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DeputadosDetalhesProfissoes extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesProfissoes({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesProfissoes> createState() =>
      _DeputadosDetalhesProfissoesState();
}

class _DeputadosDetalhesProfissoesState
    extends State<DeputadosDetalhesProfissoes> {
  late List<dynamic> profissoesDetalhes = [];

  Future<void> fetchProfissoesDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/profissoes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          profissoesDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfissoesDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profissões do Parlamentar"),
      ),
      body: profissoesDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: profissoesDetalhes.map((profissao) {
                  // Analisar a string de data para um objeto DateTime
                  DateTime dataHora = DateTime.parse(profissao['dataHora']);

                  // Formatar a data no formato desejado (DD/MM/AAAA)
                  String dataFormatada =
                      DateFormat('dd/MM/yyyy').format(dataHora);

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profissao['titulo'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(dataFormatada), // Exibe a data formatada

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
