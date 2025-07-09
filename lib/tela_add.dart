import 'package:flutter/material.dart';

class AdicionarRemedioPage extends StatefulWidget {
  const AdicionarRemedioPage({super.key});

  @override
  State<AdicionarRemedioPage> createState() => _AdicionarRemedioPageState();
}

class _AdicionarRemedioPageState extends State<AdicionarRemedioPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController comprimidosController = TextEditingController();
  final List<String> tipos = ['comprimido', 'xarope', 'gotas', 'injeção', 'vacina'];
  String tipoSelecionado = 'comprimido';
  int quantidadeDias = 1;
  int vezesAoDia = 1;

  int sintomaSelecionado = -1;

  final List<IconData> iconesSintomas = [
    Icons.headphones, // dor de cabeça
    Icons.face, // enjoo
    Icons.sick, // dor de barriga
    Icons.coronavirus, // respiratórios
    Icons.heat_pump, // febre
    Icons.medical_services, // dor de dente
    Icons.emergency, // dor abdominal
    Icons.all_inclusive, // tosse
    Icons.help_outline, // outro
  ];

  void salvarRemedio() {
    final remedio = {
      'nome': nomeController.text,
      'tipo': tipoSelecionado,
      'frequencia': '$vezesAoDia vezes ao dia',
      'duracao': '$quantidadeDias dias',
      'cor': Colors.lightBlueAccent,
      'icone': Icons.medication,
    };
    Navigator.pop(context, remedio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text('Adicionar novo Remédio', style: TextStyle(color: Colors.black)),
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
            TextField(
              controller: comprimidosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade de comprimidos',
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
              child: Text('Salvar Remédio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}