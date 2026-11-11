import 'dart:async' as async;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBTareas {
  static Database? _db;

  static async.Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas_juanpablo.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tareas ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT, '
          'descripcion TEXT, '
          'completada INTEGER'
          ')',
        );
      },
    );
    return _db!;
  }

  static async.Future<int> insertar(String titulo, String descripcion) async {
    final db = await database;
    return await db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': 0,
    });
  }

  static async.Future<List<Map<String, Object?>>> listar({bool? soloCompletadas}) async {
    final db = await database;
    if (soloCompletadas == true) {
      return await db.query('tareas', where: 'completada = ?', whereArgs: [1], orderBy: 'id DESC');
    } else if (soloCompletadas == false) {
      return await db.query('tareas', where: 'completada = ?', whereArgs: [0], orderBy: 'id DESC');
    }
    return await db.query('tareas', orderBy: 'id DESC');
  }

  static async.Future<int> actualizar(int id, String titulo, String descripcion) async {
    final db = await database;
    return await db.update(
      'tareas',
      {'titulo': titulo, 'descripcion': descripcion},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static async.Future<int> cambiarEstado(int id, bool completada) async {
    final db = await database;
    return await db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static async.Future<int> eliminar(int id) async {
    final db = await database;
    return await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}