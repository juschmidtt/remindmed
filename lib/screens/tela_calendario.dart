import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:remindmed/models/remedio.dart';

class TelaCalendario extends StatefulWidget {
  final List<Remedio> remedios;

  const TelaCalendario({super.key, required this.remedios});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late final Map<DateTime, List<Remedio>> _remediosPorDia;

  // Controle de remédios tomados por nome+horário
  Set<String> _remediosTomados = {};

  Map<DateTime, List<Remedio>> _agruparRemediosPorDia(List<Remedio> remedios) {
    Map<DateTime, List<Remedio>> map = {};

    for (final remedio in remedios) {
      final inicio = remedio.dataInicio ?? DateTime.now();

      final duracaoDias = int.tryParse(remedio.duracao.split(' ').first) ?? 1;

      for (int i = 0; i < duracaoDias; i++) {
        final data = DateTime(inicio.year, inicio.month, inicio.day).add(Duration(days: i));

        if (remedio.recorrencia == 'Diário') {
          map.putIfAbsent(data, () => []).add(remedio);
        } else if (remedio.recorrencia == 'Semanal') {
          if (data.weekday == inicio.weekday) {
            map.putIfAbsent(data, () => []).add(remedio);
          }
        } else if (remedio.recorrencia == 'Personalizado') {
          map.putIfAbsent(data, () => []).add(remedio);
        }
      }
    }

    return map;
  }

  List<Remedio> _remediosDoDia(DateTime dia) {
    final dataNormalizada = DateTime(dia.year, dia.month, dia.day);
    return _remediosPorDia[dataNormalizada] ?? [];
  }

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _selectedDay = DateTime(hoje.year, hoje.month, hoje.day);
    _remediosPorDia = _agruparRemediosPorDia(widget.remedios);
  }

  @override
  Widget build(BuildContext context) {
    final remediosDoDia = _remediosDoDia(_selectedDay!);

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          locale: 'pt_BR',
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: ListView.builder(
            itemCount: remediosDoDia.length,
            itemBuilder: (context, index) {
              final remedio = remediosDoDia[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color.fromARGB(255, 242, 243, 244),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: remedio.cor,
                      child: Icon(remedio.icone),
                    ),
                    title: Text(remedio.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(remedio.tipo),
                    children: remedio.horarios.map((horarioStr) {
                      final key = '${remedio.nome}_$horarioStr';
                      final tomado = _remediosTomados.contains(key);

                      return Dismissible(
                        key: ValueKey(key),
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (_) async {
                          setState(() {
                            _remediosTomados.add(key);
                          });
                          return false;
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: tomado ? Colors.green : remedio.cor,
                            child: tomado
                                ? const Icon(Icons.check, color: Colors.white)
                                : Icon(remedio.icone),
                          ),
                          title: Text('Horário: $horarioStr'),
                          trailing: Text(tomado ? 'Tomado' : 'Pendente',
                              style: TextStyle(
                                  color: tomado ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}