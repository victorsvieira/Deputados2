import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
                        GestureDetector(
                          onTap: () async {
                            String? url = evento['urlRegistro']
                                ?.toString(); // Verifica se a URL é nula
                            if (url != null) {
                              try {
                                String videoId = _extractYoutubeVideoId(url);
                                await _launchYoutubeUrl(videoId);
                              } catch (e) {
                                print('Erro ao abrir a URL do YouTube: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Não foi possível abrir o vídeo.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              // URL é nula, exibe uma mensagem para o usuário
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Não há vídeo disponível.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_filled,
                                  color: Colors.red), // Ícone do YouTube
                              SizedBox(
                                  width:
                                      8), // Espaçamento entre o ícone e o texto
                              Text("Assistir",
                                  style: TextStyle(
                                      color: Colors.red)), // Texto "Assistir"
                            ],
                          ),
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

// Função para extrair a ID do vídeo do YouTube da URL
String _extractYoutubeVideoId(String url) {
  RegExp regExp = RegExp(r'(?<=v=)[a-zA-Z0-9_-]+');
  Match match = regExp.firstMatch(url)!;
  return match.group(0)!;
}

Future<void> _launchYoutubeUrl(String videoId) async {
  String youtubeUrl = 'https://www.youtube.com/watch?v=' + videoId;
  if (await canLaunch(youtubeUrl)) {
    await launch(youtubeUrl);
  } else {
    throw 'Não foi possível abrir a URL do YouTube: $youtubeUrl';
  }
}
