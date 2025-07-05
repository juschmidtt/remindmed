import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum TipoMedicamento { comprimido, xarope, vacina }

class Medicamento {
  String nome;
  TipoMedicamento tipo;
  int quantidade;
  String mensagemLembrete;

  Medicamento({
    required this.nome,
    required this.tipo,
    required this.quantidade,
    required this.mensagemLembrete,
  }) {
    if (tipo == TipoMedicamento.comprimido && quantidade > 5) {
      this.quantidade = 5;
    }
  }

  List<String> gerarLembretes() {
    if (tipo == TipoMedicamento.comprimido) {
      return List.generate(
        quantidade,
        (index) => 'Comprimido ${index + 1}: $mensagemLembrete',
      );
    } else if (tipo == TipoMedicamento.xarope) {
      return ['Tomar xarope: $mensagemLembrete'];
    } else if (tipo == TipoMedicamento.vacina) {
      return List.generate(
        quantidade,
        (index) => 'Dose anual ${index + 1}: $mensagemLembrete',
      );
    } else {
      return ['Lembrete: $mensagemLembrete'];
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final r = widget.remedio;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: r['cor'],
                    radius: 28,
                    child: Icon(r['icone'], color: Colors.black, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['nome'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(r['tipo']),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r['frequencia'], style: const TextStyle(color: Colors.green)),
                      const SizedBox(height: 4),
                      Text(r['duracao'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(Icons.notifications_none),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Número de comprimidos diários"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            comprimidos = (comprimidos - 1).clamp(0, 20);
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$comprimidos',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            comprimidos++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text("Horários", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ...List.generate(horarios.length, (i) {
              return GestureDetector(
                onTap: () => editarHorario(i),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lembrete ${i + 1}"),
                      Text(
                        formatarHora(horarios[i]),
                        style: TextStyle(
                        
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Mensagem"),
                  Text("Não esqueça\ndo seu remédio!",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  TipoMedicamento _tipo = TipoMedicamento.comprimido;
  int _quantidade = 1;
  String _mensagem = '';
  List<String> _lembretes = [];

  void _aoTocar(int index) {
    setState(() {
      _indiceSelecionado = index;
    });
    // Adicione navegação futura aqui se quiser
  }

  final List<Map<String, dynamic>> remedios = [
    {
      'nome': 'Seki',
      'tipo': 'Xarope',
      'frequencia': '2 vezes ao dia',
      'duracao': '7 dias',
      'cor': Colors.lightBlueAccent,
      'icone': Icons.local_pharmacy,
    },
    {
      'nome': 'Decongex Pus',
      'tipo': 'Remédio em gotas',
      'frequencia': '3 vezes ao dia',
      'duracao': '5 dias',
      'cor': Colors.purpleAccent,
      'icone': Icons.medication_liquid,
    },
    {
      'nome': 'Amoxicilina',
      'tipo': 'Comprimido',
      'frequencia': '3 vezes ao dia',
      'duracao': '5 dias',
      'cor': Colors.cyanAccent,
      'icone': Icons.medication,
    },
    {
      'nome': 'Vacina para gripe',
      'tipo': 'Vacina',
      'frequencia': '1 vez ao dia',
      'duracao': '1 dia',
      'cor': Colors.redAccent,
      'icone': Icons.vaccines,
    },
    {
      'nome': 'Anticoncepcional',
      'tipo': 'Comprimido',
      'frequencia': '1 vez ao dia',
      'duracao': '28 dias',
      'cor': Colors.pinkAccent,
      'icone': Icons.medication_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RemindMed'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome do medicamento',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _nome = value!.trim(),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Informe o nome do medicamento'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TipoMedicamento>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de medicamento',
                      border: OutlineInputBorder(),
                    ),
                    value: _tipo,
                    items: TipoMedicamento.values.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo.name[0].toUpperCase() +
                            tipo.name.substring(1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipo = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: _getQuantidadeLabel(),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _quantidade = int.tryParse(value!) ?? 1,
                    validator: (value) {
                      final v = int.tryParse(value ?? '');
                      if (v == null || v < 1) {
                        return 'Informe um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Mensagem do lembrete',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _mensagem = value!.trim(),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Escreva uma mensagem'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _gerarLembretes,
                    icon: const Icon(Icons.alarm),
                    label: const Text('Gerar Lembretes'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_lembretes.isNotEmpty) ...[
              const Text(
                'Lembretes gerados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _lembretes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.medication),
                      title: Text(_lembretes[index]),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
