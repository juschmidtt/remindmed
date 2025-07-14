
import 'package:flutter/material.dart';
import '../models/remedio.dart';
import '../database/database.dart'; 

class AdicionarRemedioPage extends StatefulWidget {
  AdicionarRemedioPage({super.key});

  @override
  State<AdicionarRemedioPage> createState() => _AdicionarRemedioPageState();
}

class _AdicionarRemedioPageState extends State<AdicionarRemedioPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController comprimidosController = TextEditingController(); 

  final List<String> tipos = ['Comprimido', 'Xarope', 'Gotas', 'Vacina'];
  String tipoSelecionado = 'Comprimido';

  final List<String> recorrencias = ['Diário', 'Semanal', 'Mensal', 'Anual'];
  String recorrenciaSelecionada = 'Diário';

  int quantidadeDias = 1;
  int vezesAoDia = 1;
  int sintomaSelecionado = -1;

  final List<IconData> iconesSintomas = [
    Icons.healing, // dor de cabeça
    Icons.sentiment_very_dissatisfied, // enjoo
    Icons.heart_broken, // dor de barriga
    Icons.coronavirus, // respiratórios
    Icons.sick, // febre
    Icons.abc, // dor de dente
    Icons.heart_broken, // dor abdominal
    Icons.heart_broken, // tosse
    Icons.help_outline, // outro
  ];

  Map<String, dynamic> getCorEIconePorTipo(String tipo) {
    switch (tipo) {
      case 'comprimido':
        return {
          'cor': const Color.fromARGB(255, 66, 205, 244),
          'icone': Icons.medication,
        };
      case 'vacina':
        return {
          'cor': Colors.greenAccent,
          'icone': Icons.vaccines,
        };
      case 'gotas':
        return {
          'cor': const Color.fromARGB(255, 215, 61, 141),
          'icone': Icons.opacity,
        };
      case 'xarope':
        return {
          'cor': Colors.purpleAccent,
          'icone': Icons.local_drink,
        };
      default:
        return {
          'cor': Colors.lightBlueAccent,
          'icone': Icons.medication,
        };
    }
  }

  void salvarRemedio() async {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);

    final novoRemedio = Remedio(
      nome: nomeController.text,
      tipo: tipoSelecionado,
      frequencia: '$vezesAoDia vezes ao dia',
      recorrencia: recorrenciaSelecionada,
      duracao: '$quantidadeDias dias',
      corValue: (tipoInfo['cor'] as Color).value,
      iconeCodePoint: (tipoInfo['icone'] as IconData).codePoint,
      iconeFontFamily: (tipoInfo['icone'] as IconData).fontFamily!, 
      dosesDiarias: int.tryParse(comprimidosController.text) ?? 1,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.insertRemedio(novoRemedio);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          'Adicionar novo Remédio',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do remédio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: tipoSelecionado,
              decoration: InputDecoration(
                labelText: 'Tipo de remédio',
                border: OutlineInputBorder(),
              ),
              items: tipos.map((tipo) {
                return DropdownMenuItem(value: tipo, child: Text(tipo));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSelecionado = value!;
                });
              },
            ),
            SizedBox(height: 12),
            // NOVO: Dropdown para Recorrência
            DropdownButtonFormField<String>(
              value: recorrenciaSelecionada,
              decoration: InputDecoration(
                labelText: 'Recorrência',
                border: OutlineInputBorder(),
              ),
              items: recorrencias.map((recorrencia) {
                return DropdownMenuItem(
                  value: recorrencia,
                  child: Text(recorrencia),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  recorrenciaSelecionada = value!;
                });
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: comprimidosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade de doses',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text('Quantidade de dias:'),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      quantidadeDias = (quantidadeDias - 1).clamp(1, 365);
                    });
                  },
                ),
                Text('$quantidadeDias'),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      quantidadeDias++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text('Quantidade de vezes ao dia:'),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      vezesAoDia = (vezesAoDia - 1).clamp(1, 24);
                    });
                  },
                ),
                Text('$vezesAoDia'),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      vezesAoDia++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Sintomas que está tratando:'),
            SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(iconesSintomas.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      sintomaSelecionado = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sintomaSelecionado == index
                            ? Colors.blue
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      iconesSintomas[index],
                      size: 30,
                      color: sintomaSelecionado == index
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarRemedio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Salvar Remédio'),
            )
          ],
        ),
      ),
    );
  }
}