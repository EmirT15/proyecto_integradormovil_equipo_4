import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de la base de datos para escritorio (Windows, macOS, Linux)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 06 - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GestorTareasScreen(),
    );
  }
}

// ==========================================
// ACCESO A LA BASE DE DATOS LOCAL (SQLITE)
// ==========================================
class DBTareas {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = path.join(await getDatabasesPath(), 'tareas_juanpablo.db');
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

  static Future<int> insertar(String titulo, String descripcion) async {
    final db = await database;
    return await db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> listar({bool? soloCompletadas}) async {
    final db = await database;
    if (soloCompletadas == true) {
      return await db.query('tareas', where: 'completada = ?', whereArgs: [1], orderBy: 'id DESC');
    } else if (soloCompletadas == false) {
      return await db.query('tareas', where: 'completada = ?', whereArgs: [0], orderBy: 'id DESC');
    }
    return await db.query('tareas', orderBy: 'id DESC');
  }

  static Future<int> actualizar(int id, String titulo, String descripcion) async {
    final db = await database;
    return await db.update(
      'tareas',
      {'titulo': titulo, 'descripcion': descripcion},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> cambiarEstado(int id, bool completada) async {
    final db = await database;
    return await db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}

// ==========================================
// INTERFAZ DE USUARIO Y LÓGICA DE LA PANTALLA
// ==========================================
class GestorTareasScreen extends StatefulWidget {
  const GestorTareasScreen({super.key});

  @override
  State<GestorTareasScreen> createState() => _GestorTareasScreenState();
}

class _GestorTareasScreenState extends State<GestorTareasScreen> {
  List<Map<String, dynamic>> _tareas = [];
  String _filtroFiltro = 'todas'; // 'todas', 'pendientes', 'completadas'

  @override
  void initState() {
    super.initState();
    _cargarPreferenciaFiltro();
  }

  Future<void> _cargarPreferenciaFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _filtroFiltro = prefs.getString('filtro_tareas') ?? 'todas';
    });
    _cargarTareas();
  }

  Future<void> _guardarPreferenciaFiltro(String nuevoFiltro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filtro_tareas', nuevoFiltro);
    setState(() {
      _filtroFiltro = nuevoFiltro;
    });
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    bool? soloCompletadas;
    if (_filtroFiltro == 'completadas') soloCompletadas = true;
    if (_filtroFiltro == 'pendientes') soloCompletadas = false;

    final datos = await DBTareas.listar(soloCompletadas: soloCompletadas);
    setState(() {
      _tareas = datos;
    });
  }

  void _mostrarFormulario({Map<String, dynamic>? tarea}) {
    final tituloController = TextEditingController(text: tarea?['titulo'] ?? '');
    final descController = TextEditingController(text: tarea?['descripcion'] ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tarea == null ? 'Nueva Tarea' : 'Editar Tarea'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Ingresa un título' : null,
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (tarea == null) {
                  await DBTareas.insertar(tituloController.text, descController.text);
                } else {
                  await DBTareas.actualizar(tarea['id'], tituloController.text, descController.text);
                }
                if (mounted) Navigator.pop(context);
                _cargarTareas();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DBTareas.eliminar(id);
              if (mounted) Navigator.pop(context);
              _cargarTareas();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor Offline - JuanPablo'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _filtroFiltro,
            onSelected: _guardarPreferenciaFiltro,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'todas', child: Text('Mostrar Todas')),
              PopupMenuItem(value: 'pendientes', child: Text('Solo Pendientes')),
              PopupMenuItem(value: 'completadas', child: Text('Solo Completadas')),
            ],
          )
        ],
      ),
      body: _tareas.isEmpty
          ? const Center(child: Text('No hay tareas disponibles.'))
          : ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final t = _tareas[index];
                final esCompletada = t['completada'] == 1;

                return ListTile(
                  leading: Checkbox(
                    value: esCompletada,
                    onChanged: (val) async {
                      await DBTareas.cambiarEstado(t['id'], val ?? false);
                      _cargarTareas();
                    },
                  ),
                  title: Text(
                    t['titulo'],
                    style: TextStyle(
                      decoration: esCompletada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(t['descripcion'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(tarea: t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(t['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}