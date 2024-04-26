import 'package:deputados/blocosDetalhes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Blocos extends StatefulWidget {
  const Blocos({super.key});

  @override
  State<Blocos> createState() => _BlocosState();
}

class _BlocosState extends State<Blocos> {
  List<Map<String, dynamic>> blocos = [];

  Future<List<Map<String, dynamic>>> fetchBlocos() async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/blocos?ordem=ASC&ordenarPor=nome'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData.containsKey('dados')) {
        final blocosData = jsonData['dados'];

        List<Map<String, dynamic>> blocosList = [];

        for (var bloco in blocosData) {
          Map<String, dynamic> blocoMap = {
            'id': bloco['id'],
            'idLegislatura': bloco['idLegislatura'],
            'nome': bloco['nome'],
            'uri': bloco['uri'],
          };
          blocosList.add(blocoMap);
        }
        return blocosList;
      } else {
        throw Exception('Dados de blocos parlamentares não encontrados');
      }
    } else {
      throw Exception('Falha ao carregar os dados dos blocos parlamentares');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlocos().then((blocosData) {
      setState(() {
        blocos = blocosData;
      });
    }).catchError((error) {
      print('Erro ao carregar os blocos: $error');
      // Lógica de tratamento de erro, se necessário
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocos Partidários"),
      ),
      body: blocos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: blocos.length,
              itemBuilder: (context, index) {
                final bloco = blocos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      bloco['nome'],
                    ),

                    onTap: () {
                      print(bloco['id']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocosDetalhes(blocoId: bloco['id']),
                        ),
                      );
                      // Adicione aqui a ação ao clicar no card, se necessário
                    },
                    // Outros detalhes ou ações que deseja adicionar para cada bloco
                  ),
                );
              },
            ),
    );
  }
}
