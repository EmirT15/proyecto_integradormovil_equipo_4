import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/incidencia_model.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'incidencias.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incidencias(
            id TEXT PRIMARY KEY,
            titulo TEXT,
            descripcion TEXT,
            categoria TEXT,
            fotoPath TEXT,
            latitud REAL,
            longitud REAL,
            fechaHora TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertar(IncidenciaModel item) async {
    final db = await database;
    await db.insert(
      'incidencias',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<IncidenciaModel>> obtenerTodas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('incidencias', orderBy: 'fechaHora DESC');
    return List.generate(maps.length, (i) => IncidenciaModel.fromMap(maps[i]));
  }
}