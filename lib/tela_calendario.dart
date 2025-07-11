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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            focusedDay: _focado,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
            onDaySelected: (selected, focused) {
              setState(() {
                _diaSelecionado = selected;
                _focado = focused;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: const Color.fromARGB(255, 0, 204, 255), shape: BoxShape.circle),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
            ),
          ),
        ],
      ),
    );
  }
}