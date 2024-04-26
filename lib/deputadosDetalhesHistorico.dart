import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeputadosDetalhesHistorico extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesHistorico({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesHistorico> createState() =>
      _DeputadosDetalhesHistoricoState();
}

class _DeputadosDetalhesHistoricoState
    extends State<DeputadosDetalhesHistorico> {
  late List<dynamic> historicoDetalhes = [];

  Future<void> fetchHistoricoDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/historico'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          historicoDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHistoricoDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico do Parlamentar"),
      ),
      body: historicoDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: historicoDetalhes.map((historico) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(historico['nomeEleitoral'].toString()),
                        Text(historico['siglaPartido'].toString()),
                        Text(historico['dataHora'].toString()),
                        Text(historico['situacao'].toString()),
                        Text(historico['condicaoEleitoral'].toString()),
                        Text(historico['descricaoStatus'].toString()),

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
