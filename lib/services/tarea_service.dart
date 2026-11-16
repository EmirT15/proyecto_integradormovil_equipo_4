import '../database/db.dart';
import '../models/tarea.dart';

class TareaService {
  // Crear una tarea.
  static Future<int> insertar(Tarea tarea) async {
    final db = await DB.database;

    return await db.insert('tareas', tarea.toMap());
  }

  // Consultar todas las tareas.
  static Future<List<Tarea>> listar() async {
    final db = await DB.database;

    final resultado = await db.query('tareas', orderBy: 'id DESC');

    return resultado.map((map) => Tarea.fromMap(map)).toList();
  }

  // Actualizar una tarea.
  static Future<int> actualizar(Tarea tarea) async {
    final db = await DB.database;

    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  // Eliminar una tarea.
  static Future<int> eliminar(int id) async {
    final db = await DB.database;

    return await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}
