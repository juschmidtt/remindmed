import 'package:flutter/material.dart';
import '../models/remedio.dart';
import '../database/database.dart';

class AdicionarRemedioPage extends StatefulWidget {
  final Remedio? remedioExistente;
  AdicionarRemedioPage({super.key, this.remedioExistente});

  @override
  State<AdicionarRemedioPage> createState() => _AdicionarRemedioPageState();
}

class _AdicionarRemedioPageState extends State<AdicionarRemedioPage> {
  late TextEditingController nomeController;
  String tipoSelecionado = 'Comprimido';
  String recorrenciaSelecionada = 'Diário';
  int quantidadeDias = 1;
  int vezesAoDia = 1;

  final List<String> tipos = ['Comprimido', 'Xarope', 'Gotas', 'Vacina'];
  final List<String> recorrencias = ['Diário', 'Semanal', 'Mensal', 'Anual', 'Personalizado'];

  @override
  void initState() {
    super.initState();

    if (widget.remedioExistente != null) {
      final r = widget.remedioExistente!;
      nomeController = TextEditingController(text: r.nome);
      tipoSelecionado = r.tipo;
      recorrenciaSelecionada = r.recorrencia;
      if (recorrenciaSelecionada == 'Personalizado') {
        final dias = int.tryParse(r.duracao.split(' ').first) ?? 1;
        quantidadeDias = dias;
      }
      vezesAoDia = r.dosesDiarias;
    } else {
      nomeController = TextEditingController();
    }

    nomeController.addListener(() {
      setState(() {});
    });
  }

  Map<String, dynamic> getCorEIconePorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'comprimido':
        return {'cor': Color(0xFF42CDF4), 'icone': Icons.medication};
      case 'vacina':
        return {'cor': Colors.greenAccent, 'icone': Icons.vaccines};
      case 'gotas':
        return {'cor': Color(0xFFD73D8D), 'icone': Icons.opacity};
      case 'xarope':
        return {'cor': Colors.purpleAccent, 'icone': Icons.local_drink};
      default:
        return {'cor': Colors.lightBlueAccent, 'icone': Icons.medication};
    }
  }

  void salvarRemedio() async {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);

    final novoRemedio = Remedio(
      id: widget.remedioExistente?.id,
      nome: nomeController.text,
      tipo: tipoSelecionado,
      frequencia: '$vezesAoDia vezes ao dia',
      recorrencia: recorrenciaSelecionada,
      duracao: recorrenciaSelecionada == 'Personalizado'
          ? '$quantidadeDias dias'
          : recorrenciaSelecionada,
      corValue: (tipoInfo['cor'] as Color).value,
      iconeCodePoint: (tipoInfo['icone'] as IconData).codePoint,
      iconeFontFamily: (tipoInfo['icone'] as IconData).fontFamily!,
      dosesDiarias: vezesAoDia,
    );

    final dbHelper = DatabaseHelper();
    if (widget.remedioExistente == null) {
      await dbHelper.insertRemedio(novoRemedio);
    } else {
      await dbHelper.updateRemedio(novoRemedio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoInfo = getCorEIconePorTipo(tipoSelecionado);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          widget.remedioExistente == null ? 'Adicionar novo Remédio' : 'Editar Remédio',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: tipoInfo['cor'],
                  radius: 28,
                  child: Icon(tipoInfo['icone'], color: Colors.black, size: 28),
                ),
                title: Text(
                  nomeController.text.isEmpty ? 'Nome do remédio' : nomeController.text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(tipoSelecionado),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$vezesAoDia vezes ao dia', style: TextStyle(color: Colors.green)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          recorrenciaSelecionada == 'Personalizado'
                              ? '$quantidadeDias dias'
                              : recorrenciaSelecionada,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.notifications_none, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nomeController,
              onChanged: (_) {
                setState(() {});
                salvarRemedio();
              },
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
              items: tipos.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSelecionado = value!;
                });
                salvarRemedio();
              },
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: recorrenciaSelecionada,
              decoration: const InputDecoration(
                labelText: 'Recorrência',
                border: OutlineInputBorder(),
              ),
              items: recorrencias.map((recorrencia) => DropdownMenuItem(
                value: recorrencia,
                child: Text(recorrencia),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  recorrenciaSelecionada = value!;
                  if (recorrenciaSelecionada != 'Personalizado') {
                    quantidadeDias = 1;
                  }
                });
                salvarRemedio();
              },
            ),
            const SizedBox(height: 12),

            if (recorrenciaSelecionada == 'Personalizado')
              Row(
                children: [
                  const Text('Quantidade de dias:'),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        quantidadeDias = (quantidadeDias - 1).clamp(1, 365);
                      });
                      salvarRemedio();
                    },
                  ),
                  Text('$quantidadeDias'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        quantidadeDias++;
                      });
                      salvarRemedio();
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
                    salvarRemedio();
                  },
                ),
                Text('$vezesAoDia'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      vezesAoDia++;
                    });
                    salvarRemedio();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}