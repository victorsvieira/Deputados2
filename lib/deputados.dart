import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'deputado_card.dart';

class Deputados extends StatefulWidget {
  const Deputados({super.key});

  @override
  State<Deputados> createState() => _DeputadosState();
}

class _DeputadosState extends State<Deputados> {
  String apiGender = '';
  Future<List<Map<String, String>>> fetchDeputados({
    String? siglaUf,
    String? siglaPartido,
    String? siglaSexo,
  }) async {
    setState(() {});
    final Map<String, String> queryParams = {};

    if (siglaUf != null) {
      queryParams['siglaUf'] = siglaUf;
    }
    if (siglaPartido != null) {
      queryParams['siglaPartido'] = siglaPartido;
    }
    if (siglaSexo != null) {
      queryParams['siglaSexo'] = siglaSexo;
    }

    final uri = Uri.https(
      'dadosabertos.camara.leg.br',
      '/api/v2/deputados',
      {'ordem': 'ASC', 'ordenarPor': 'nome', ...queryParams},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.containsKey('dados')) {
        final deputados = jsonData['dados'];

        List<Map<String, String>> deputadosList = [];

        for (var deputado in deputados) {
          Map<String, String> deputadoMap = {
            'id': deputado['id'].toString(),
            'nome': deputado['nome'],
            'siglaPartido': deputado['siglaPartido'],
            'uriPartido': deputado['uriPartido'],
            'siglaUf': deputado['siglaUf'],
            'idLegislatura': deputado['idLegislatura'].toString(),
            'urlFoto': deputado['urlFoto'],
            'email': deputado['email'],
          };
          deputadosList.add(deputadoMap);
        }

        return deputadosList;
      } else {
        throw Exception('Dados de deputados não encontrados');
      }
    } else {
      throw Exception('Falha ao carregar os dados');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchParties();
  }

  late List<Map<String, dynamic>> parties = [];
  String selectedState = 'Todos';
  String selectedParty = 'Todos';
  String selectedGender = 'Todos';

  Future<void> fetchParties() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/partidos?ordem=ASC&ordenarPor=sigla'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['dados'];

      setState(() {
        parties = data
            .map<Map<String, dynamic>>(
              (dynamic item) => {
                'id': item['id'],
                'nome': item['nome'],
                'sigla': item['sigla'],
                'uri': item['uri'],
              },
            )
            .toList();
      });
    } else {
      throw Exception('Falha ao carregar os partidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determina a orientação do dispositivo
    final orientation = MediaQuery.of(context).orientation;

    // Define o número de colunas com base na orientação
    int crossAxisCount = orientation == Orientation.portrait ? 1 : 2;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showFilterModal(context);
            },
            icon: const Icon(Icons.filter_alt),
            iconSize: 35,
          )
        ],
        title: const Text("Lista de Deputados"),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        key: UniqueKey(),
        future: fetchDeputados(
          siglaUf: selectedState != 'Todos' ? selectedState : null,
          siglaPartido: selectedParty != 'Todos' ? selectedParty : null,
          siglaSexo: apiGender.isNotEmpty ? apiGender : null,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("\nCarregando informações..."),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final deputados = snapshot.data;

            if (deputados == null || deputados.isEmpty) {
              return const Center(child: Text('Nenhum deputado encontrado.'));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    crossAxisCount, // Define o número de colunas na grade
                crossAxisSpacing: 8.0, // Espaçamento horizontal entre os itens
                mainAxisSpacing: 8.0, // Espaçamento vertical entre os itens
              ),
              itemCount: deputados.length,
              itemBuilder: (context, index) {
                final deputado = deputados[index];
                return DeputadoCard(
                  nome: deputado['nome'] ?? '',
                  siglaPartido: deputado['siglaPartido'] ?? '',
                  siglaUf: deputado['siglaUf'] ?? '',
                  urlFoto: deputado['urlFoto'] ?? '',
                  idDeputado: deputado['id'] ?? '',
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    String tempSelectedState = selectedState;
    String tempSelectedParty = selectedParty;
    String tempSelectedGender = selectedGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filtrar por:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Estado',
                      value: tempSelectedState,
                      items: [
                        'Todos',
                        'AC',
                        'AL',
                        'AP',
                        'AM',
                        'BA',
                        'CE',
                        'ES',
                        'GO',
                        'MA',
                        'MT',
                        'MS',
                        'MG',
                        'PA',
                        'PB',
                        'PR',
                        'PE',
                        'PI',
                        'RJ',
                        'RN',
                        'RS',
                        'RO',
                        'RR',
                        'SC',
                        'SP',
                        'SE',
                        'TO',
                        'DF',
                      ],
                      onChanged: (value) {
                        setState(() {
                          tempSelectedState = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Partido',
                      value: tempSelectedParty,
                      items: [
                        'Todos',
                        for (var party in parties) party['sigla']
                      ],
                      onChanged: (value) {
                        setState(() {
                          tempSelectedParty = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Sexo',
                      value: tempSelectedGender,
                      items: ['Todos', 'Masculino', 'Feminino'],
                      onChanged: (value) {
                        setState(() {
                          tempSelectedGender = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          selectedState = tempSelectedState;
                          selectedParty = tempSelectedParty;
                          selectedGender = tempSelectedGender;
                        });

                        String mapGenderValue(String selectedGender) {
                          if (selectedGender == 'Masculino') {
                            return 'M';
                          } else if (selectedGender == 'Feminino') {
                            return 'F';
                          } else {
                            return '';
                          }
                        }

                        apiGender = mapGenderValue(selectedGender);

                        try {
                          List<Map<String, String>> filteredDeputados =
                              await fetchDeputados(
                            siglaUf:
                                selectedState != 'Todos' ? selectedState : null,
                            siglaPartido:
                                selectedParty != 'Todos' ? selectedParty : null,
                            siglaSexo: apiGender.isNotEmpty ? apiGender : null,
                          );
                        } catch (e) {
                          //
                        }
                      },
                      child: const Text('Aplicar Filtros'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: value,
          onChanged: (String? newValue) {
            onChanged(newValue);
          },
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
