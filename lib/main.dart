import 'dart:async' as async;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de la base de datos para entorno de escritorio (Windows, macOS, Linux)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MiAppGuiada());
}

class MiAppGuiada extends StatelessWidget {
  const MiAppGuiada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 06 - Ejercicio Guiado JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ActividadGuiadaScreen(),
    );
  }
}

// ==========================================
// PARTE B: CLASE DE ACCESO A LA BASE DE DATOS (DB)
// ==========================================
class DB {
  static Database? _db;

  static async.Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = path.join(await getDatabasesPath(), 'notas_juanpablo.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notas ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'titulo TEXT, '
        'contenido TEXT, '
        'pendiente_sincronizar INTEGER DEFAULT 1'
        ')',
      ),
    );
    return _db!;
  }

  static async.Future<int> insertar(String titulo, String contenido) async {
    final db = await database;
    return db.insert('notas', {
      'titulo': titulo,
      'contenido': contenido,
      'pendiente_sincronizar': 1,
    });
  }

  static Future<List<Map<String, Object?>>> listar() async {
    final db = await database;
    return db.query('notas', orderBy: 'id DESC');
  }

  static async.Future<int> actualizar(int id, String titulo, String contenido) async {
    final db = await database;
    return db.update(
      'notas',
      {
        'titulo': titulo,
        'contenido': contenido,
        'pendiente_sincronizar': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static async.Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}

// ==========================================
// ACTIVIDAD GUIADA (PANTALLA PRINCIPAL)
// ==========================================
class ActividadGuiadaScreen extends StatefulWidget {
  const ActividadGuiadaScreen({super.key});

  @override
  State<ActividadGuiadaScreen> createState() => _ActividadGuiadaScreenState();
}

class _ActividadGuiadaScreenState extends State<ActividadGuiadaScreen> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();

  List<Map<String, dynamic>> _notas = [];
  String _nombreUsuario = 'Invitado';
  int? _notaSeleccionadaId;

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
    _cargarNotas();
  }

  // PARTE A: SharedPreferences
  async.Future<void> _cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre_usuario') ?? 'JuanPablo';
      _nombreUsuarioController.text = _nombreUsuario;
    });
  }

  async.Future<void> _guardarNombreUsuario(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre_usuario', nombre);
    setState(() {
      _nombreUsuario = nombre;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre de usuario guardado')),
      );
    }
  }

  // PARTE B: Operaciones SQLite
  async.Future<void> _cargarNotas() async {
    final datos = await DB.listar();
    setState(() {
      _notas = datos;
    });
  }

  void _limpiarFormulario() {
    _tituloController.clear();
    _contenidoController.clear();
    setState(() {
      _notaSeleccionadaId = null;
    });
  }

  async.Future<void> _guardarOActualizarNota() async {
    final titulo = _tituloController.text.trim();
    final contenido = _contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa título y contenido')),
      );
      return;
    }

    if (_notaSeleccionadaId == null) {
      await DB.insertar(titulo, contenido);
    } else {
      await DB.actualizar(_notaSeleccionadaId!, titulo, contenido);
    }

    _limpiarFormulario();
    _cargarNotas();
  }

  void _cargarNotaParaEditar(Map<String, dynamic> nota) {
    setState(() {
      _notaSeleccionadaId = nota['id'];
      _tituloController.text = nota['titulo'];
      _contenidoController.text = nota['contenido'];
    });
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DB.eliminar(id);
              if (_notaSeleccionadaId == id) {
                _limpiarFormulario();
              }
              if (mounted) Navigator.pop(context);
              _cargarNotas();
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
        title: Text('Notas de: $_nombreUsuario'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección SharedPreferences (Nombre del usuario)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nombreUsuarioController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de Usuario (SharedPreferences)',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => _guardarNombreUsuario(_nombreUsuarioController.text),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Formulario con dos TextField y botones Guardar/Actualizar
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la nota',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contenidoController,
              decoration: const InputDecoration(
                labelText: 'Contenido de la nota',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(_notaSeleccionadaId == null ? Icons.add : Icons.edit),
                    label: Text(_notaSeleccionadaId == null ? 'Guardar Nota' : 'Actualizar Nota'),
                    onPressed: _guardarOActualizarNota,
                  ),
                ),
                if (_notaSeleccionadaId != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _limpiarFormulario,
                    child: const Text('Cancelar'),
                  ),
                ],
              ],
            ),
            const Divider(height: 25),

            // Muestra DB.listar() en ListView
            Expanded(
              child: _notas.isEmpty
                  ? const Center(child: Text('No hay notas registradas.'))
                  : ListView.builder(
                      itemCount: _notas.length,
                      itemBuilder: (context, index) {
                        final nota = _notas[index];
                        final esPendiente = nota['pendiente_sincronizar'] == 1;

                        return Card(
                          child: ListTile(
                            onTap: () => _cargarNotaParaEditar(nota),
                            title: Text(nota['titulo']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nota['contenido']),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      esPendiente ? Icons.cloud_off : Icons.cloud_done,
                                      size: 16,
                                      color: esPendiente ? Colors.orange : Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      esPendiente ? 'Pendiente de sincronizar' : 'Sincronizado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: esPendiente ? Colors.orange : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarEliminacion(nota['id']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}