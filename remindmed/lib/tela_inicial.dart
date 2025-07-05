import 'package:flutter/material.dart';

class DetalheRemedioPage extends StatefulWidget {
  final Map<String, dynamic> remedio;

  const DetalheRemedioPage({super.key, required this.remedio});

  @override
  State<DetalheRemedioPage> createState() => _DetalheRemedioPageState();
}

class _DetalheRemedioPageState extends State<DetalheRemedioPage> {
  int comprimidos = 3;
  List<TimeOfDay> horarios = [
    const TimeOfDay(hour: 8, minute: 30),
    const TimeOfDay(hour: 16, minute: 30),
    const TimeOfDay(hour: 0, minute: 30),
  ];

  String formatarHora(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> editarHorario(int index) async {
    final novo = await showTimePicker(
      context: context,
      initialTime: horarios[index],
    );
    if (novo != null) {
      setState(() {
        horarios[index] = novo;
      });
    }
  }

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
                          color: Color.fromARGB(255, 78, 173, 228),
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
  int _indiceSelecionado = 0;

  void _aoTocar(int index) {
    setState(() {
      _indiceSelecionado = index;
    });

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 40),
            const SizedBox(width: 8),
            const Text(
              'RemindMed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 173, 228),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: remedios.length,
        itemBuilder: (context, index) {
          final r = remedios[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalheRemedioPage(remedio: r),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: r['cor'],
                    radius: 28,
                    child: Icon(r['icone'], color: Colors.black, size: 28),
                  ),
                  title: Text(
                    r['nome'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(r['tipo']),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        r['frequencia'],
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            r['duracao'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.notifications_none, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _indiceSelecionado,
          onTap: _aoTocar,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.place), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: ''),
          ],
        ),
      ),
    );
  }
}