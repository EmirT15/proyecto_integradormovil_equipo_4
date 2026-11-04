import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBTareas {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas_app.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE tareas ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'titulo TEXT, '
        'descripcion TEXT, '
        'completada INTEGER DEFAULT 0)',
      ),
    );
    return _db!;
  }

  static Future<int> insertar(String titulo, String descripcion) async {
    final db = await database;
    return db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> listar(String filtro) async {
    final db = await database;
    if (filtro == 'completadas') {
      return db.query('tareas', where: 'completada = ?', whereArgs: [1], orderBy: 'id DESC');
    } else if (filtro == 'pendientes') {
      return db.query('tareas', where: 'completada = ?', whereArgs: [0], orderBy: 'id DESC');
    }
    return db.query('tareas', orderBy: 'id DESC');
  }

  static Future<int> cambiarEstado(int id, bool completada) async {
    final db = await database;
    return db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> actualizar(int id, String titulo, String descripcion) async {
    final db = await database;
    return db.update(
      'tareas',
      {'titulo': titulo, 'descripcion': descripcion},
      where: 'id = ?',
      whereArgs: [id],
    );    
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}