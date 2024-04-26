import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DeputadosDetalhesDespesas extends StatefulWidget {
  final String deputadoId;

  const DeputadosDetalhesDespesas({super.key, required this.deputadoId});

  @override
  State<DeputadosDetalhesDespesas> createState() =>
      _DeputadosDetalhesDespesasState();
}

class _DeputadosDetalhesDespesasState extends State<DeputadosDetalhesDespesas> {
  late List<dynamic> despesasDetalhes = [];

  Future<void> fetchDespesasDetalhes(String id) async {
    final response = await http.get(Uri.parse(
        'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/despesas?ordem=ASC&ordenarPor=ano'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty && jsonData.containsKey('dados')) {
        setState(() {
          despesasDetalhes = jsonData['dados'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDespesasDetalhes(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Despesas do Parlamentar"),
      ),
      body: despesasDetalhes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: despesasDetalhes.map((despesa) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(text: "Tipo: "),
                            TextSpan(
                              text: "${despesa['tipoDespesa'].toString()}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Valor: ",
                              ),
                              TextSpan(
                                text: formatarValor(despesa['valorDocumento']),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                            'Data: ${despesa['mes'].toString()}/${despesa['ano'].toString()}'),

                        Text(
                            "Documento: ${despesa['tipoDocumento'].toString()}"),
                        Text(
                            "Fornecedor: ${despesa['nomeFornecedor'].toString()}"),
                        Text(
                            "CNPJ: ${formatarCNPJ(despesa['cnpjCpfFornecedor'].toString())}"),

                        const Divider(), // Adiciona uma linha divisória entre despesas
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

String formatarCNPJ(String cnpj) {
  // Verifica se o CNPJ tem 14 caracteres
  if (cnpj.length != 14) {
    return 'CNPJ inválido';
  }

  // Insere os pontos e barras no CNPJ
  return "${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}";
}

String formatarValor(double valor) {
  // Cria um formatador de moeda brasileira
  NumberFormat formatoMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // Formata o valor
  return formatoMoeda.format(valor);
}
