import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TelaCalendario extends StatefulWidget {
  final List<Map<String, dynamic>> remedios;

  const TelaCalendario({super.key, required this.remedios});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime _diaSelecionado = DateTime.now();
  DateTime _focado = DateTime.now();

  List<Map<String, dynamic>> getRemediosDoDia(DateTime dia) {
    return widget.remedios.where((remedio) {
      final DateTime inicio = remedio['inicio'];
      final int duracao = int.tryParse(remedio['duracao'].toString().split(' ').first) ?? 1;
      final fim = inicio.add(Duration(days: duracao - 1));

      return dia.isAtSameMomentAs(inicio) ||
          (dia.isAfter(inicio) && dia.isBefore(fim.add(const Duration(days: 1))));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final listaDoDia = getRemediosDoDia(_diaSelecionado);

    return SingleChildScrollView(
      child: Column(
        children: [
        TableCalendar(
          locale: 'pt_BR',
          focusedDay: _focado,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
          onDaySelected: (selected, focused) {
            setState(() {
              _diaSelecionado = selected;
              _focado = focused;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
          ),
        ),
        const SizedBox(height: 16),
        ...listaDoDia.map((r) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: r['cor'],
                  child: Icon(r['icone'], color: Colors.white),
                ),
                title: Text(r['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(r['tipo']),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(r['frequencia'], style: const TextStyle(color: Colors.green)),
                    Text(r['duracao'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
}