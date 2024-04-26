import 'package:flutter/material.dart';

class Votacoes extends StatefulWidget {
  const Votacoes({super.key});

  @override
  State<Votacoes> createState() => _VotacoesState();
}

class _VotacoesState extends State<Votacoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Votacoes"),
      ),
      body: Container(
        child: const Text("Votacoes"),
      ),
    );
  }
}
