import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/producto_model.dart';

class InventarioDbService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'inventario.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos(
            id TEXT PRIMARY KEY,
            nombre TEXT,
            sku TEXT,
            cantidad INTEGER,
            precio REAL,
            fotoPath TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertar(ProductoModel prod) async {
    final db = await database;
    await db.insert('productos', prod.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ProductoModel>> obtenerProductos() async {
    final db = await database;
    final maps = await db.query('productos');
    return List.generate(maps.length, (i) => ProductoModel.fromMap(maps[i]));
  }
}