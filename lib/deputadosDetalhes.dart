import 'package:deputados/deputadosDetalhesFrentes.dart';
import 'package:deputados/deputadosDetalhesHistorico.dart';

import 'package:deputados/deputadosDetalhesMandatos.dart';
import 'package:deputados/deputadosDetalhesOcupacoes.dart';
import 'package:deputados/deputadosDetalhesOrgaos.dart';
import 'package:deputados/deputadosDetalhesProfissoes.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'deputadosDetalhesDespesas.dart';
import 'deputadosDetalhesDiscursos.dart';
import 'deputadosDetalhesEventos.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeputadosDetalhes extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhes({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhes> createState() => _DeputadosDetalhesState();
}

class _DeputadosDetalhesState extends State<DeputadosDetalhes> {
  late Map<String, dynamic> deputadosDetalhes = {};

  Future<void> fetchDeputadosDetalhes(String id) async {
    final response = await http.get(
        Uri.parse('https://dadosabertos.camara.leg.br/api/v2/deputados/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          deputadosDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeputadosDetalhes(widget.deputadoId.toString());
  }

  Future<void> _launchUrl(String url) async {
    final Uri urlPronta = Uri.parse(url);

    if (!await launchUrl(urlPronta)) {
      throw Exception('Could not launch $url');
    }
  }

  String formatarCPF(String cpf) {
    return cpf.substring(0, 3) +
        '.' +
        cpf.substring(3, 6) +
        '.' +
        cpf.substring(6, 9) +
        '-' +
        cpf.substring(9);
  }

  @override
  Widget build(BuildContext context) {
    // Implemente aqui o layout para exibir os detalhes do evento
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do parlamentar'),
        ),
        body: deputadosDetalhes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            deputadosDetalhes['ultimoStatus']
                                                ['urlFoto'],
                                            width: 15,
                                            height: 200,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\n${deputadosDetalhes['nomeCivil']}",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                '\n"${deputadosDetalhes['ultimoStatus']['nomeEleitoral']}"\n',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      _buildInfoRow(Icons.group,
                                                          "Partido: ${deputadosDetalhes['ultimoStatus']['siglaPartido']} (${deputadosDetalhes['ultimoStatus']['siglaUf']})"),
                                                      _buildInfoRow(
                                                          Icons.school,
                                                          "Escolaridade: ${deputadosDetalhes['escolaridade']}"),
                                                      _buildInfoRow(Icons.info,
                                                          "Situação: ${deputadosDetalhes['ultimoStatus']['situacao']}"),
                                                      _buildInfoRow(
                                                          Icons.how_to_vote,
                                                          "Condição eleitoral: ${deputadosDetalhes['ultimoStatus']['condicaoEleitoral']}"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  _buildInfoRow(
                                                      Icons.location_city,
                                                      "Naturalidade: ${deputadosDetalhes['municipioNascimento']} - ${deputadosDetalhes['ufNascimento']}, em ${DateFormat('dd/MM/yyyy').format(DateTime.parse(deputadosDetalhes['dataNascimento']))}"),
                                                  _buildInfoRow(Icons.phone,
                                                      "Telefone: ${deputadosDetalhes['ultimoStatus']['gabinete']['telefone']}"),
                                                  _buildInfoRow(Icons.business,
                                                      "Gabinete ${deputadosDetalhes['ultimoStatus']['gabinete']['nome']}, prédio ${deputadosDetalhes['ultimoStatus']['gabinete']['predio']}, andar ${deputadosDetalhes['ultimoStatus']['gabinete']['andar']}, sala ${deputadosDetalhes['ultimoStatus']['gabinete']['sala']}"),
                                                  _buildInfoRow(Icons.email,
                                                      "Email: ${deputadosDetalhes['ultimoStatus']['gabinete']['email']}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                spacing: 10,
                                                runSpacing: 10,
                                                children: deputadosDetalhes[
                                                        'redeSocial']
                                                    .map<Widget>((redeSocial) {
                                                  IconData iconData;
                                                  if (redeSocial.contains(
                                                      'twitter.com')) {
                                                    iconData = FontAwesomeIcons
                                                        .twitter;
                                                  } else if (redeSocial
                                                      .contains(
                                                          'instagram.com')) {
                                                    iconData = FontAwesomeIcons
                                                        .instagram;
                                                  } else if (redeSocial
                                                      .contains(
                                                          'facebook.com')) {
                                                    iconData = FontAwesomeIcons
                                                        .facebook;
                                                  } else if (redeSocial
                                                      .contains(
                                                          'whatsapp.com')) {
                                                    iconData = FontAwesomeIcons
                                                        .whatsapp;
                                                  } else if (redeSocial
                                                      .contains(
                                                          'youtube.com')) {
                                                    iconData = FontAwesomeIcons
                                                        .youtube;
                                                  } else {
                                                    iconData =
                                                        FontAwesomeIcons.link;
                                                  }

                                                  return ElevatedButton.icon(
                                                    onPressed: () =>
                                                        _launchUrl(redeSocial),
                                                    icon: Icon(iconData),
                                                    label: Text("Acessar"),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity, // Largura máxima

                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing:
                                              10, // Espaçamento horizontal entre os botões
                                          runSpacing:
                                              10, // Espaçamento vertical entre as linhas de botões
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeputadosDetalhesDespesas(
                                                            deputadoId:
                                                                deputadosDetalhes[
                                                                        'id']
                                                                    .toString()),
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.attach_money),
                                              label: Text("Despesas"),
                                            ),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesEventos(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon:
                                                    Icon(Icons.event_available),
                                                label: const Text("Eventos")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesFrentes(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.people_alt),
                                                label: const Text(
                                                    "Frentes parlamentares")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesHistorico(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.history),
                                                label: const Text("Histórico")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesMandatos(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons
                                                    .account_tree_outlined),
                                                label: const Text(
                                                    "Mandatos Externos")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesOcupacoes(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.home_work),
                                                label: const Text("Ocupações")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesOrgaos(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                    Icons.workspaces_filled),
                                                label: const Text("Órgãos")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeputadosDetalhesProfissoes(
                                                              deputadoId:
                                                                  deputadosDetalhes[
                                                                          'id']
                                                                      .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.work),
                                                label:
                                                    const Text("Profissões")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ));
  }
}

Widget textoRedeSocial(String redeSocial) {
  if (redeSocial.contains('twitter')) {
    return const Text('Twitter');
  } else if (redeSocial.contains('facebook')) {
    return const Text('Facebook');
  } else if (redeSocial.contains('instagram')) {
    return const Text('Instagram');
  } else if (redeSocial.contains('youtube')) {
    return const Text('Youtube');
  } else {
    return Text(redeSocial);
  }
}

Widget _buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon), // Ícone
        SizedBox(width: 8), // Espaço entre o ícone e o texto
        Flexible(child: Text(text)), // Texto
      ],
    ),
  );
}


// SizedBox(
//                               width: 150,
//                               height: 200,
//                               child: Image.network(
//                                 deputadosDetalhes['ultimoStatus']['urlFoto'],
//                                 fit: BoxFit.fitHeight,
//                               ),
//                             ),
