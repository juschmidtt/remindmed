import 'package:flutter/material.dart';

class AdicionarRemedioPage extends StatefulWidget {
  const AdicionarRemedioPage({super.key});

  @override
  State<AdicionarRemedioPage> createState() => _AdicionarRemedioPageState();
}

class _AdicionarRemedioPageState extends State<AdicionarRemedioPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController comprimidosController = TextEditingController();

  final List<String> tipos = ['comprimido', 'xarope', 'gotas', 'vacina'];
  String tipoSelecionado = 'comprimido';

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

  void salvarRemedio() {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);

    final remedio = {
      'nome': nomeController.text,
      'tipo': tipoSelecionado,
      'frequencia': '$vezesAoDia vezes ao dia',
      'recorrencia': recorrenciaSelecionada, // nova info
      'duracao': '$quantidadeDias dias',
      'cor': tipoInfo['cor'],
      'icone': tipoInfo['icone'],
      'sintoma': sintomaSelecionado >= 0 ? iconesSintomas[sintomaSelecionado] : null,
    };

    Navigator.pop(context, remedio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          'Adicionar novo Remédio',
          style: TextStyle(color: Colors.black),
        ),
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
            // NOVO: Dropdown para Recorrência
            DropdownButtonFormField<String>(
              value: recorrenciaSelecionada,
              decoration: const InputDecoration(
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
            const SizedBox(height: 12),
            TextField(
              controller: comprimidosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade de doses',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Quantidade de dias:'),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Salvar Remédio'),
            )
          ],
        ),
      ),
    );
  }
}
