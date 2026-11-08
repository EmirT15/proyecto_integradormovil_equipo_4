import '../database/db.dart';
import '../models/nota.dart';

class NotaService {
  // Crear una nota.
  static Future<int> insertar(Nota nota) async {
    final db = await DB.database;

    return await db.insert('notas', nota.toMap());
  }

  // Consultar todas las notas.
  static Future<List<Nota>> listar() async {
    final db = await DB.database;

    final resultado = await db.query('notas', orderBy: 'id DESC');

    return resultado.map((map) => Nota.fromMap(map)).toList();
  }

  // Actualizar una nota.
  static Future<int> actualizar(Nota nota) async {
    final db = await DB.database;

    return await db.update(
      'notas',
      nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  // Eliminar una nota.
  static Future<int> eliminar(int id) async {
    final db = await DB.database;

    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
