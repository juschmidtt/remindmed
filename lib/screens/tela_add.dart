import 'package:flutter/material.dart';
import '../models/remedio.dart';
import '../database/database.dart';

class AdicionarRemedioPage extends StatefulWidget {
  const AdicionarRemedioPage({super.key});

  @override
  State<AdicionarRemedioPage> createState() => _AdicionarRemedioPageState();
}

class _AdicionarRemedioPageState extends State<AdicionarRemedioPage> {
  final TextEditingController nomeController = TextEditingController();

  final List<String> tipos = ['Comprimido', 'Xarope', 'Gotas', 'Vacina'];
  String tipoSelecionado = 'Comprimido';

  final List<String> recorrencias = ['Diário', 'Semanal', 'Mensal', 'Anual', 'Personalizado'];
  String recorrenciaSelecionada = 'Diário';

  int quantidadeDias = 1;
  int vezesAoDia = 1;

  List<TimeOfDay> horarios = [];

  Map<String, dynamic> getCorEIconePorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'comprimido':
        return {'cor': Color(0xFF42CDF4), 'icone': Icons.medication};
      case 'xarope':
        return {'cor': Color(0xFFB15BFF), 'icone': Icons.local_drink};
      case 'gotas':
        return {'cor': Color(0xFFFFBD42), 'icone': Icons.opacity};
      case 'vacina':
        return {'cor': Color(0xFF40B959), 'icone': Icons.vaccines};
      default:
        return {'cor': Colors.grey, 'icone': Icons.medication};
    }
  }

  void inicializarHorarios() {
    horarios = List.generate(
      vezesAoDia,
      (index) => TimeOfDay(hour: (8 + (index * 2)) % 24, minute: 0),
    );
  }

  void salvarRemedio() async {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);
    final IconData icone = tipoInfo['icone'];

    final List<String> horariosFormatados = horarios.map((t) {
      final hourStr = t.hour.toString().padLeft(2, '0');
      final minuteStr = t.minute.toString().padLeft(2, '0');
      return '$hourStr:$minuteStr';
    }).toList();

    final novoRemedio = Remedio(
      id: null,
      nome: nomeController.text,
      tipo: tipoSelecionado,
      frequencia: '$vezesAoDia ${vezesAoDia == 1 ? 'vez' : 'vezes'} ao dia',
      duracao: recorrenciaSelecionada == 'Personalizado'
          ? '$quantidadeDias dias'
          : recorrenciaSelecionada,
      recorrencia: recorrenciaSelecionada,
      corValue: tipoInfo['cor'].value,
      iconeCodePoint: icone.codePoint,
      iconeFontFamily: icone.fontFamily ?? '',
      dosesDiarias: vezesAoDia,
      mensagem: '',
      horarios: horariosFormatados,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.insertRemedio(novoRemedio);

    if (!mounted) return;
    Navigator.pop(context, true);  // Envia true para sinalizar que adicionou
  }

  Widget buildPreviewDetalhe() {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);
    final icone = tipoInfo['icone'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: tipoInfo['cor'],
            radius: 28,
            child: Icon(icone, color: Colors.black, size: 28),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeController.text.isEmpty ? 'Nome do remédio' : nomeController.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(tipoSelecionado),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$vezesAoDia ${vezesAoDia == 1 ? "vez" : "vezes"} ao dia',
                  style: TextStyle(color: Colors.green)),
              SizedBox(height: 4),
              Text(
                recorrenciaSelecionada == 'Personalizado'
                    ? '$quantidadeDias dias'
                    : recorrenciaSelecionada,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.notifications_none),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nomeController.addListener(() => setState(() {}));
    inicializarHorarios();
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  Future<void> selecionarHorario(int index) async {
    final TimeOfDay? novoHorario = await showTimePicker(
      context: context,
      initialTime: horarios[index],
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 118, 178, 228), // cor de destaque
              onPrimary: Colors.white, // texto nos botões
              onSurface: Colors.black, // texto normal
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.blue,
              dialBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
            ),
          ),
          child: child!,
        );
      },
    );
    if (novoHorario != null) {
      setState(() {
        horarios[index] = novoHorario;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Adicionar Remédio'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildPreviewDetalhe(),
            SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do remédio',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: tipoSelecionado,
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
              items: tipos
                  .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                  .toList(),
              onChanged: (valor) => setState(() => tipoSelecionado = valor!),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: recorrenciaSelecionada,
              decoration: InputDecoration(
                labelText: 'Recorrência',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
              items: recorrencias
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (valor) => setState(() => recorrenciaSelecionada = valor!),
            ),
            if (recorrenciaSelecionada == 'Personalizado') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Quantidade de dias:'),
                  IconButton(
                    onPressed: () => setState(() => quantidadeDias = (quantidadeDias - 1).clamp(1, 365)),
                    icon: Icon(Icons.remove_circle_outline, color: Colors.black),
                  ),
                  Text('$quantidadeDias'),
                  IconButton(
                    onPressed: () => setState(() => quantidadeDias = (quantidadeDias + 1).clamp(1, 365)),
                    icon: Icon(Icons.add_circle_outline, color: Colors.black),
                  ),
                ],
              ),
            ],
            SizedBox(height: 12),
            Row(
              children: [
                Text('Vezes ao dia:'),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.black),
                  onPressed: () {
                    if (vezesAoDia > 1) {
                      setState(() {
                        vezesAoDia = (vezesAoDia - 1).clamp(1, 20);
                        inicializarHorarios();
                      });
                    }
                  },
                ),
                Text('$vezesAoDia'),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.black),
                  onPressed: () {
                    if (vezesAoDia < 20) {
                      setState(() {
                        vezesAoDia = (vezesAoDia + 1).clamp(1, 20);
                        inicializarHorarios();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Horários:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ...List.generate(horarios.length, (index) {
                  final horario = horarios[index];
                  final horarioFormatado = horario.format(context);
                  return ListTile(
                    title: Text('Horário ${index + 1}: $horarioFormatado'),
                    trailing: Icon(Icons.edit),
                    onTap: () => selecionarHorario(index),
                  );
                }),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: salvarRemedio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}