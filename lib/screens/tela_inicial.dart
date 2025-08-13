import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:remindmed/screens/tela_add.dart';
import 'package:remindmed/screens/tela_calendario.dart';
import 'package:remindmed/screens/tela_farmacia.dart';
import 'dart:async';
import '../models/remedio.dart';
import '../database/database.dart';

class DetalheRemedioPage extends StatefulWidget {
  final Remedio remedio;

  const DetalheRemedioPage({super.key, required this.remedio});

  @override
  State<DetalheRemedioPage> createState() => _DetalheRemedioPageState();
}

class _DetalheRemedioPageState extends State<DetalheRemedioPage> {
  late int comprimidos;
  late List<TimeOfDay> horarios;

  late TextEditingController mensagemController;

  final FlutterLocalNotificationsPlugin _notificacoesPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _setupTimeZone() async {
    tz.initializeTimeZones();
    String name;
    try {
      name = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      name = 'America/Sao_Paulo'; 
    }
    tz.setLocalLocation(tz.getLocation(name));
    print('[DEBUG] Timezone configurado: $name');
  }

  @override
  void initState() {
    super.initState();
    comprimidos = widget.remedio.dosesDiarias;
    if (widget.remedio.horarios.isNotEmpty) {
      horarios = widget.remedio.horarios.map((h) {
        final parts = h.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }).toList();
    } else {
      horarios = List.generate(
        comprimidos,
        (index) => TimeOfDay(hour: 8 + (index * 2) % 24, minute: 0),
      );
    }
    mensagemController = TextEditingController(text: widget.remedio.mensagem);

    mensagemController.addListener(() {
      widget.remedio.mensagem = mensagemController.text;
    });

    _setupTimeZone().then((_) {
      _configurarNotificacoes().then((_) {
        agendarNotificacoes();
      });
      _testarNotificacao();
    });
  }

  Future<void> _configurarNotificacoes() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin, 
    );

    await _notificacoesPlugin.initialize(settings);

    // Permissões Android 13+
    final androidPlugin = _notificacoesPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    // Permissões iOS/macOS
    final iosPlugin = _notificacoesPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  String _timeZoneName() {
    try {
      return tz.local.name;
    } catch (_) {
      return 'America/Sao_Paulo';
    }
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  tz.TZDateTime _proximoHorario(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now.add(Duration(seconds: 5)))) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> agendarNotificacoes() async {
    await _notificacoesPlugin.cancel(widget.remedio.id!);
    if (horarios.isEmpty) return;

    for (int i = 0; i < horarios.length; i++) {
      final time = horarios[i];
      final scheduledDate = _proximoHorario(time);
      print('[DEBUG] Agendando notificação para ${scheduledDate.toLocal()} do remédio ${widget.remedio.nome}');
      final idNotificacao = widget.remedio.id! * 10 + i;
      await _notificacoesPlugin.zonedSchedule(
        idNotificacao,
        'Hora do remédio: ${widget.remedio.nome}',
        widget.remedio.mensagem,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'remedios_channel',
            'Lembretes de Remédios',
            channelDescription: 'Notificações para lembrar de tomar remédios',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
  Future<void> _testarNotificacao() async {
    final agora = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
    await _notificacoesPlugin.zonedSchedule(
      9999, // id de teste
      'Teste de notificação',
      'Se você recebeu, está funcionando!',
      agora,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'teste_channel',
          'Teste',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  String formatarHora(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> editarHorario(int index) async {
    final novo = await showTimePicker(
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
    if (novo != null) {
      setState(() {
        horarios[index] = novo;
        widget.remedio.horarios = horarios
            .map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
            .toList();
      });
      await _salvarAlteracoes();
      await agendarNotificacoes();
    }
  }

  Future<void> _salvarAlteracoes() async {
    widget.remedio.dosesDiarias = comprimidos;
    widget.remedio.horarios = horarios
        .map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
        .toList();
    widget.remedio.mensagem = mensagemController.text;

    final dbHelper = DatabaseHelper();
    await dbHelper.updateRemedio(widget.remedio);
  }

  Future<void> confirmarExclusao() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Remédio'),
        content: Text('Tem certeza que deseja excluir este remédio?'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteRemedio(widget.remedio.id!);
      Navigator.pop(context, true);
    }
  }

  // void _salvarAlteracoes() async {
  //   widget.remedio.dosesDiarias = comprimidos;
  //   widget.remedio.mensagem = mensagemController.text;

  //   final dbHelper = DatabaseHelper();
  //   await dbHelper.updateRemedio(widget.remedio);

  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('Remédio atualizado com sucesso!')));
  // }

  @override
  Widget build(BuildContext context) {
    final r = widget.remedio;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: confirmarExclusao,
            tooltip: 'Excluir remédio',
          ),
        ],
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
                    backgroundColor: r.cor,
                    radius: 28,
                    child: Icon(r.icone, color: Colors.black, size: 28),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.nome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(r.tipo),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r.frequencia, style: TextStyle(color: Colors.green)),
                      SizedBox(height: 4),
                      Text(
                        r.duracao,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.notifications_none),
                    ],
                  ),
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
                  Text("Número de doses diárias"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            comprimidos = (comprimidos - 1).clamp(1, 20);
                            if (comprimidos < horarios.length) {
                              horarios.removeLast();
                            }
                          });
                          await _salvarAlteracoes();
                          await agendarNotificacoes();
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
                        onPressed: () async {
                          setState(() {
                            comprimidos++;
                            if (comprimidos > horarios.length) {
                              horarios.add(TimeOfDay(hour: 8, minute: 0));
                            } else if (comprimidos < horarios.length) {
                              horarios.removeLast();
                            }
                          });
                          await _salvarAlteracoes();
                          await agendarNotificacoes();
                        },
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Horários",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _indiceSelecionado = 1;
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
    if (!mounted) return;
    setState(() {
      remedios = loadedRemedios;
    });
  }

  void _atualizarHora() {
    setState(() {
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
      body: () {
        switch (_indiceSelecionado) {
          case 0:
            return Padding(
              padding: EdgeInsets.all(16),
              child: TelaCalendario(remedios: remedios),
            );
          case 1:
            return Column(
              children: [
                SizedBox(height: 12),
                SizedBox(height: 12),
                Expanded(
                  child: remedios.isEmpty
                      ? Center(child: Text('Nenhum remédio adicionado ainda.'))
                      : ListView.builder(
                          itemCount: remedios.length,
                          itemBuilder: (context, index) {
                            final r = remedios[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: Dismissible(
                                key: Key(r.id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Excluir Remédio'),
                                      content: Text('Tem certeza que deseja excluir este remédio?'),
                                      backgroundColor: const Color.fromARGB(255, 242, 243, 244),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('Excluir', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) async {
                                  final dbHelper = DatabaseHelper();
                                  await dbHelper.deleteRemedio(r.id!);
                                  setState(() {
                                    remedios.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
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
                                    contentPadding: EdgeInsets.all(12),
                                    leading: CircleAvatar(
                                      backgroundColor: r.cor,
                                      radius: 28,
                                      child: Icon(r.icone, color: Colors.black, size: 28),
                                    ),
                                    title: Text(r.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(r.tipo),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(r.frequencia, style: TextStyle(color: Colors.green)),
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
            );
          case 2:
            return TelaFarmacia();
          default:
            return Container();
        }
      }(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarRemedioPage()),
          ).then((novoRemedioAdicionado) {
            if (novoRemedioAdicionado == true) {
              _carregarRemedios();
            }
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Adicionar Remédio',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        currentIndex: _indiceSelecionado,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Seus remédios'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Farmácias'),
        ],
      ),
    );
  }
}
