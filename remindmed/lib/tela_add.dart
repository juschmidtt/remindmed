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
    Icons.face,       // enjoo
    Icons.sick,       // dor de barriga
    Icons.coronavirus, // sintomas respiratórios
    Icons.heat_pump,  // febre
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
    Navigator.pop(context, remedio); // devolve o remédio para quem chamou
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Adicionar novo Remédio', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do remédio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: tipoSelecionado,
              decoration: const InputDecoration(
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
            const SizedBox(height: 12),
            TextField(
              controller: comprimidosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade de comprimidos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Quantidade de dias:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      quantidadeDias = (quantidadeDias - 1).clamp(1, 365);
                    });
                  },
                ),
                Text('$quantidadeDias'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      quantidadeDias++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Quantidade de vezes ao dia:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      vezesAoDia = (vezesAoDia - 1).clamp(1, 24);
                    });
                  },
                ),
                Text('$vezesAoDia'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      vezesAoDia++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Sintomas que está tratando:'),
            const SizedBox(height: 8),
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
                    padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarRemedio,
              child: const Text('Salvar Remédio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}