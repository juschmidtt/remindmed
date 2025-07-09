
import 'package:flutter/material.dart';
import 'package:remindmed/tela_add.dart';
import 'package:remindmed/tela_calendario.dart';

class DetalheRemedioPage extends StatefulWidget {
  final Map<String, dynamic> remedio;

  const DetalheRemedioPage({super.key, required this.remedio});

  @override
  State<DetalheRemedioPage> createState() => _DetalheRemedioPageState();
}

class _DetalheRemedioPageState extends State<DetalheRemedioPage> {
  int comprimidos = 3;
  List<TimeOfDay> horarios = [
    TimeOfDay(hour: 8, minute: 30),
    TimeOfDay(hour: 16, minute: 30),
    TimeOfDay(hour: 0, minute: 30),
  ];

  String formatarHora(TimeOfDay t) {
    final h = t.hour.toString();
    final m = t.minute.toString();
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
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: r['cor'],
                    radius: 28,
                    child: Icon(r['icone'], color: Colors.black, size: 28),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['nome'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(r['tipo']),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r['frequencia'], style: TextStyle(color: Colors.green)),
                      SizedBox(height: 4),
                      Text(r['duracao'], style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.notifications_none),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Número de comprimidos diários"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            comprimidos = (comprimidos - 1).clamp(0, 20);
                          });
                        },
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$comprimidos',
                        style: TextStyle(
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
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Text("Horários", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            ...List.generate(horarios.length, (i) {
              return GestureDetector(
                onTap: () => editarHorario(i),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mensagem"),
                  Text("Não esqueça do seu remédio!",
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

  final List<Map<String, dynamic>> remedios = [
    {
      'nome': 'Seki',
      'tipo': 'Xarope',
      'frequencia': '2 vezes ao dia',
      'duracao': '3 dias',
      'cor': Colors.lightBlueAccent,
      'icone': Icons.local_pharmacy,
      'inicio': DateTime(2025, 2, 9),
    },
    {
      'nome': 'Vacina para gripe',
      'tipo': 'Vacina',
      'frequencia': '1 vez ao dia',
      'duracao': '1 dia',
      'cor': Colors.pinkAccent,
      'icone': Icons.vaccines,
      'inicio': DateTime(2025, 2, 26),
    },
    {
      'nome': 'Anticoncepcional',
      'tipo': 'Comprimido',
      'frequencia': '1 vez ao dia',
      'duracao': '28 dias',
      'cor': Colors.pinkAccent,
      'icone': Icons.medication_outlined,
      'inicio': DateTime(2025, 2, 10),
    },
  ];

  void _onTap(int index) {
    setState(() {
      _indiceSelecionado = index;
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdicionarRemedioPage()),
        ).then((novoRemedio) {
          if (novoRemedio != null) {
            setState(() {
              remedios.add({...novoRemedio, 'inicio': DateTime.now()});
            });
          }
        });
      }
    });
  }

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
      body: _indiceSelecionado == 1
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: TelaCalendario(remedios: remedios),
            )
          : ListView.builder(
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _indiceSelecionado,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar remédio'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Farmácias'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Estoque'),
        ],
      ),
    );
  }
}