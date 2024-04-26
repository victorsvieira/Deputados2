import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class DeputadosDetalhesEventos extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesEventos({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesEventos> createState() =>
      _DeputadosDetalhesEventosState();
}

class _DeputadosDetalhesEventosState extends State<DeputadosDetalhesEventos> {
  late List<dynamic> eventosDetalhes = [];

  Future<void> fetchevEventosDetalhes(String id) async {
    print(id);
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/eventos?ordem=ASC&ordenarPor=dataHoraInicio'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          eventosDetalhes = jsonData['dados'];
        });
      }
    } else {
      print("Não deu certo a comunicação com a API!");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchevEventosDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos do Parlamentar"),
      ),
      body: eventosDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventosDetalhes.map((evento) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento['descricaoTipo'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                            "Início ${formatarDataHora(evento['dataHoraInicio'].toString())} até ${formatarDataHora(evento['dataHoraFim'].toString())}"),

                        Text("Situação: ${evento['situacao'].toString()}"),
                        Text("Descrição: ${evento['descricao'].toString()}"),
                        Text(
                            "Órgão: ${evento['orgaos'][0]['nome'].toString()} - ${evento['orgaos'][0]['sigla'].toString()}"),
                        Text(
                            "Local: ${evento['localCamara']['nome'].toString()}"),
                        Text("Assistir: ${evento['urlRegistro'].toString()}"),

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

String formatarDataHora(String dataHora) {
  // Formatar a data
  if (dataHora != null) {
    return "-";
  }
  DateTime data = DateTime.parse(dataHora);
  String dataFormatada = DateFormat('dd/MM/yyyy').format(data);

  // Formatar a hora
  String horaFormatada = DateFormat('HH:mm').format(data);

  // Combina a hora e a data formatadas
  return '$horaFormatada do dia $dataFormatada';
}
