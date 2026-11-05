import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0,
            pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
    return _db!;
  }

  // CREATE
  static Future<int> insertar(Tarea t) async {
    final db = await database;
    return db.insert('tareas', t.toMap());
  }

  // READ
  static Future<List<Tarea>> listar() async {
    final db = await database;
    final rows = await db.query('tareas', orderBy: 'id DESC');
    return rows.map(Tarea.fromMap).toList();
  }

  // UPDATE
  static Future<int> actualizar(Tarea t) async {
    final db = await database;
    return db.update('tareas', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  // DELETE
  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}
