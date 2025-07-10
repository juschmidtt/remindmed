import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
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