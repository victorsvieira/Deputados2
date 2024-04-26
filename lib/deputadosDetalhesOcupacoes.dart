import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeputadosDetalhesOcupacoes extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesOcupacoes({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesOcupacoes> createState() =>
      _DeputadosDetalhesOcupacoesState();
}

class _DeputadosDetalhesOcupacoesState
    extends State<DeputadosDetalhesOcupacoes> {
  late List<dynamic> ocupacoesDetalhes = [];

  Future<void> fetchOcupacoesDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/ocupacoes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          ocupacoesDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOcupacoesDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ocupações do Parlamentar"),
      ),
      body: ocupacoesDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ocupacoesDetalhes.map((ocupacao) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ocupacao['titulo'] != null
                            ? ocupacao['titulo'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['entidade'] != null
                            ? ocupacao['entidade'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['entidadeUF'] != null
                            ? ocupacao['entidadeUF'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['entidadePais'] != null
                            ? ocupacao['entidadePais'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['anoFim'] != null
                            ? ocupacao['anoFim'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['anoInicio'] != null
                            ? ocupacao['anoInicio'].toString()
                            : "Nenhuma informação disponível"),
                        Text(ocupacao['anoFim'] != null
                            ? ocupacao['anoFim'].toString()
                            : "Nenhuma informação disponível"),

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
