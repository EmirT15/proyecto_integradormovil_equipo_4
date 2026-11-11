import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/incidencia_model.dart';

class IncidenciaDBService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'incidencias_juanpablo.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE incidencias ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'titulo TEXT, '
        'descripcion TEXT, '
        'categoria TEXT, '
        'rutaFoto TEXT, '
        'latitud REAL, '
        'longitud REAL, '
        'fechaHora TEXT)',
      ),
    );
    return _db!;
  }

  static Future<int> insertar(IncidenciaModel inc) async {
    final db = await database;
    return db.insert('incidencias', inc.toMap());
  }

  static Future<List<IncidenciaModel>> listar() async {
    final db = await database;
    final res = await db.query('incidencias', orderBy: 'id DESC');
    return res.map((e) => IncidenciaModel.fromMap(e)).toList();
  }
}