import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/db_tareas.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TareasPage(),
    ));

class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  List<Map<String, dynamic>> _tareas = [];
  String _filtro = 'todas'; // 'todas', 'pendientes', 'completadas'
  int? _idEdicion;

  @override
  void initState() {
    super.initState();
    _cargarFiltroPreferencia();
  }

  Future<void> _cargarFiltroPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _filtro = prefs.getString('filtro_tarea') ?? 'todas';
    });
    _refrescarTareas();
  }

  Future<void> _guardarFiltroPreferencia(String nuevoFiltro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filtro_tarea', nuevoFiltro);
    setState(() {
      _filtro = nuevoFiltro;
    });
    _refrescarTareas();
  }

  Future<void> _refrescarTareas() async {
    final datos = await DBTareas.listar(_filtro);
    setState(() {
      _tareas = datos;
    });
  }

  void _limpiarForm() {
    _tituloCtrl.clear();
    _descCtrl.clear();
    setState(() => _idEdicion = null);
  }

  void _abrirFormularioModal([Map<String, dynamic>? tarea]) {
    if (tarea != null) {
      _idEdicion = tarea['id'];
      _tituloCtrl.text = tarea['titulo'];
      _descCtrl.text = tarea['descripcion'];
    } else {
      _limpiarForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _idEdicion == null ? 'Nueva Tarea' : 'Editar Tarea',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final t = _tituloCtrl.text.trim();
                final d = _descCtrl.text.trim();
                if (t.isEmpty) return;

                if (_idEdicion == null) {
                  await DBTareas.insertar(t, d);
                } else {
                  await DBTareas.actualizar(_idEdicion!, t, d);
                }

                if (ctx.mounted) Navigator.pop(ctx);
                _limpiarForm();
                _refrescarTareas();
              },
              child: Text(_idEdicion == null ? 'Crear' : 'Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _eliminarTarea(int id) async {
    await DBTareas.eliminar(id);
    _refrescarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor Offline de Tareas'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _filtro,
            icon: const Icon(Icons.filter_list),
            onSelected: _guardarFiltroPreferencia,
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'todas', child: Text('Mostrar Todas')),
              PopupMenuItem(value: 'pendientes', child: Text('Solo Pendientes')),
              PopupMenuItem(value: 'completadas', child: Text('Solo Completadas')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blueGrey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtro persistente actual: ${_filtro.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const Icon(Icons.offline_bolt, color: Colors.green),
              ],
            ),
          ),
          Expanded(
            child: _tareas.isEmpty
                ? const Center(child: Text('No hay tareas registradas en este filtro.'))
                : ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (ctx, i) {
                      final item = _tareas[i];
                      final esCompletada = item['completada'] == 1;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Checkbox(
                            value: esCompletada,
                            onChanged: (val) async {
                              await DBTareas.cambiarEstado(item['id'], val ?? false);
                              _refrescarTareas();
                            },
                          ),
                          title: Text(
                            item['titulo'],
                            style: TextStyle(
                              decoration: esCompletada ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(item['descripcion']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _abrirFormularioModal(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarTarea(item['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioModal(),
        child: const Icon(Icons.add),
      ),
    );
  }
}