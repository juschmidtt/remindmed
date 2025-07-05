import 'package:flutter/material.dart';
import 'tela_inicial.dart';

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
      home: TelaInicial(),
    );
  }
}