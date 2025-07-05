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
    return MaterialApp(
      title: 'RemindMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TelaInicial(),
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

  void _gerarLembretes() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final medicamento = Medicamento(
        nome: _nome,
        tipo: _tipo,
        quantidade: _quantidade,
        mensagemLembrete: _mensagem,
      );

      setState(() {
        _lembretes = medicamento.gerarLembretes();
      });
    }
  }

  String _getQuantidadeLabel() {
    switch (_tipo) {
      case TipoMedicamento.comprimido:
        return 'Nº de comprimidos por dia (máx. 5)';
      case TipoMedicamento.xarope:
        return 'Doses de xarope por dia';
      case TipoMedicamento.vacina:
        return 'Nº de doses anuais da vacina';
    }
  }

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
