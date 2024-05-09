import 'package:deputados/deputadosDetalhes.dart';
import 'package:flutter/material.dart';

class DeputadoCard extends StatelessWidget {
  final String nome;
  final String siglaPartido;
  final String siglaUf;
  final String urlFoto;
  final String idDeputado;

  const DeputadoCard({
    super.key,
    required this.nome,
    required this.siglaPartido,
    required this.siglaUf,
    required this.urlFoto,
    required this.idDeputado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(urlFoto),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$siglaPartido ($siglaUf)",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeputadosDetalhes(deputadoId: idDeputado),
                    ),
                  );
                },
                child: const Text('Detalhes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
