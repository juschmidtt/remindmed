import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/remedio.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'remindmed_database.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE remedios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        tipo TEXT,
        frequencia TEXT,
        recorrencia TEXT,
        duracao TEXT,
        corValue INTEGER,
        iconeCodePoint INTEGER,
        iconeFontFamily TEXT,
        mensagem TEXT DEFAULT "Não esqueça do seu remédio!",
        dosesDiarias INTEGER DEFAULT 1
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
    }
    if (oldVersion < 1 && newVersion >= 1) {
      var tableInfo = await db.rawQuery("PRAGMA table_info(remedios)");
      if (!tableInfo.any((column) => column['name'] == 'mensagem')) {
        await db.execute("ALTER TABLE remedios ADD COLUMN mensagem TEXT DEFAULT 'Não esqueça do seu remédio!'");
      }
      if (!tableInfo.any((column) => column['name'] == 'dosesDiarias')) {
        await db.execute("ALTER TABLE remedios ADD COLUMN dosesDiarias INTEGER DEFAULT 1");
      }
    }
  }



  Future<int> insertRemedio(Remedio remedio) async {
    Database db = await database;
    return await db.insert('remedios', remedio.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Remedio>> getRemedios() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('remedios');

    return List.generate(maps.length, (i) {
      return Remedio.fromMap(maps[i]);
    });
  }

  Future<int> updateRemedio(Remedio remedio) async {
    Database db = await database;
    return await db.update(
      'remedios',
      remedio.toMap(),
      where: 'id = ?',
      whereArgs: [remedio.id],
    );
  }

  Future<int> deleteRemedio(int id) async {
    Database db = await database;
    return await db.delete(
      'remedios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}