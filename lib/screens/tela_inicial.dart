import 'package:flutter/material.dart';
import 'package:remindmed/screens/tela_add.dart';
import 'package:remindmed/tela_calendario.dart';
import 'dart:async';
import '../models/remedio.dart'; 
import '../database/database.dart';

class DetalheRemedioPage extends StatefulWidget {
  final Remedio remedio; 

  DetalheRemedioPage({
    super.key,
    required this.remedio,
  });

  @override
  State<DetalheRemedioPage> createState() => _DetalheRemedioPageState();
}

class _DetalheRemedioPageState extends State<DetalheRemedioPage> {
  late int comprimidos;
  late TextEditingController mensagemController;

  @override
  void initState() {
    super.initState();
    comprimidos = widget.remedio.dosesDiarias;
    mensagemController = TextEditingController(text: widget.remedio.mensagem);

    mensagemController.addListener(() {
      widget.remedio.mensagem = mensagemController.text;
      _salvarAlteracoes();
    });
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() async {
    widget.remedio.dosesDiarias = comprimidos;
    widget.remedio.mensagem = mensagemController.text;

    final dbHelper = DatabaseHelper();
    await dbHelper.updateRemedio(widget.remedio);
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
        padding: const EdgeInsets.all(16),
        child: Column(
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
                    backgroundColor: r.cor,
                    radius: 28,
                    child: Icon(r.icone, color: Colors.black, size: 28), 
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.nome,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(r.tipo),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r.frequencia, style: TextStyle(color: Colors.green)),
                      SizedBox(height: 4),
                      Text(r.duracao, style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.notifications_none),
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
                  const Text("Número de doses diárias"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            comprimidos = (comprimidos - 1).clamp(0, 20);
                            _salvarAlteracoes();
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
                            _salvarAlteracoes();
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
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
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mensagem"),
                  Expanded(
                    child: TextField(
                      controller: mensagemController,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Parte 2: TelaInicial
class TelaInicial extends StatefulWidget {
  TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _indiceSelecionado = 0;
  String _horaAtual = '';
  late Timer _timer;

  List<Remedio> remedios = []; 

  @override
  void initState() {
    super.initState();
    _atualizarHora();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _atualizarHora());
    _carregarRemedios();
  }

  Future<void> _carregarRemedios() async {
    final dbHelper = DatabaseHelper();
    final loadedRemedios = await dbHelper.getRemedios();
    setState(() {
      remedios = loadedRemedios;
    });
  }

  void _atualizarHora() {
    final agora = DateTime.now();
    setState(() {
      _horaAtual =
          '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _indiceSelecionado = index;
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdicionarRemedioPage()),
        ).then((novoRemedioAdicionado) {
          if (novoRemedioAdicionado == true) { 
            _carregarRemedios(); 
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
            SizedBox(width: 8),
            Text(
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
              padding: EdgeInsets.all(16),
              child: TelaCalendario(remedios: remedios),
            )
          : Column(
              children: [
                SizedBox(height: 12),
                Expanded(
                  child: remedios.isEmpty
                      ? Center(child: Text('Nenhum remédio adicionado ainda.'))
                      : ListView.builder(
                          itemCount: remedios.length,
                          itemBuilder: (context, index) {
                            final r = remedios[index];
                            return Dismissible(
                              key: ValueKey(r.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Excluir Remédio'),
                                    content: Text('Deseja realmente excluir este remédio?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancelar'),
                                        onPressed: () => Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: Text('Excluir', style: TextStyle(color: Colors.red)),
                                        onPressed: () => Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) async {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.deleteRemedio(r.id!);
                                _carregarRemedios();
                              },
                              child: GestureDetector(
                                onTap: () async {
                                  final foiAlteradoOuExcluido = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalheRemedioPage(remedio: r),
                                    ),
                                  );
                                  if (foiAlteradoOuExcluido == true) {
                                    _carregarRemedios();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                      backgroundColor: r.cor,
                                      radius: 28,
                                      child: Icon(r.icone, color: Colors.black, size: 28),
                                    ),
                                    title: Text(
                                      r.nome,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(r.tipo),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          r.frequencia,
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              r.duracao,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.notifications_none, size: 20),
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
                ),
              ],
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
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Farmácias'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Estoque'),
        ],
      ),
    );
  }
}