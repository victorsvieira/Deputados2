import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deputados',
      theme: ThemeData(
          fontFamily: 'Arial', // Define a fonte para 'Roboto'

          colorSchemeSeed: Colors.green,
          appBarTheme: const AppBarTheme(elevation: 0),
          useMaterial3: false,
          iconTheme: IconThemeData(color: Colors.green[900])),
      home: const Home(),
    );
  }
}
