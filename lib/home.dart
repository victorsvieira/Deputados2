import 'package:deputados/legislaturas.dart';
import 'package:flutter/material.dart';
import 'deputados.dart';
import 'blocos.dart';
import 'eventos.dart';
import 'frentes.dart';
import 'orgaos.dart';
import 'proposicoes.dart';
import 'votacoes.dart';
import 'partidos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Câmara dos Deputados"),
      ),
      drawer: Drawer(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.green[900], // Define a cor do texto
                ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListView(
              children: [
                // DrawerHeader(
                //   child:  age/2023/01/img20221121104428093-768x512.jpg",
                //   ),
                // ),
                ListTile(
                  leading: Icon(
                    Icons.group_sharp,
                    color: Colors.green[900],
                  ), // Ícone
                  title: Text("Deputados"), // Texto
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Deputados()),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.handshake_rounded,
                    color: Colors.green[900],
                  ),
                  title: const Text("Blocos Partidários"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Blocos()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.event_available,
                    color: Colors.green[900],
                  ),
                  title: const Text("Eventos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Eventos()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.handshake_rounded,
                    color: Colors.green[900],
                  ),
                  title: const Text("Frentes Parlamentares"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Frentes()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.library_books_rounded,
                    color: Colors.green[900],
                  ),
                  title: const Text("Legislaturas"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Legislaturas()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.workspaces_filled,
                    color: Colors.green[900],
                  ),
                  title: const Text("Órgãos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Orgaos()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.local_police_outlined,
                    color: Colors.green[900],
                  ),
                  title: const Text("Partidos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Partidos()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.article,
                    color: Colors.green[900],
                  ),
                  title: const Text("Proposições"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Proposicoes()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.how_to_vote_rounded,
                    color: Colors.green[900],
                  ),
                  title: const Text("Votações"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Votacoes()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Olá! 👋😊\n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Seja muito bem-vindo(a) ! 💚\n\nAqui você encontra diversas informações públicas a respeito da Câmara dos Deputados.\n\nAproveite para ficar atento(a) à essas informações. A participação popular é essencial para fiscalizar deputados, acompanhar seu trabalho e cobrá-los caso não estejam cumprindo sua função adequadamente.\n\n👆 Começe clicando no menu à esquerda e explore as possibilidades. Bom proveito! ✨",
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
