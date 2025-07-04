import 'package:flutter/material.dart';
import 'tela_inicial.dart'; // Importa sua tela

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemindMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TelaInicial(), // Define a tela inicial
    );
  }
}