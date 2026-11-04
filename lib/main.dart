import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/db_notas.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotasPage(),
    ));

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _tituloCtrl = TextEditingController();
  final _contenidoCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();

  List<Map<String, dynamic>> _notas = [];
  int? _idSeleccionado;
  String _nombreUsuario = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
    _refrescarNotas();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre_usuario') ?? 'Invitado';
      _usuarioCtrl.text = _nombreUsuario;
    });
  }

  Future<void> _guardarNombre() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre_usuario', _usuarioCtrl.text.trim());
    setState(() {
      _nombreUsuario = _usuarioCtrl.text.trim();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre de usuario guardado en SharedPreferences')),
      );
    }
  }

  Future<void> _refrescarNotas() async {
    final datos = await DBNotas.listar();
    setState(() {
      _notas = datos;
    });
  }

  void _limpiarFormulario() {
    _tituloCtrl.clear();
    _contenidoCtrl.clear();
    setState(() => _idSeleccionado = null);
  }

  Future<void> _guardarOActualizar() async {
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) return;

    if (_idSeleccionado == null) {
      await DBNotas.insertar(titulo, contenido);
    } else {
      await DBNotas.actualizar(_idSeleccionado!, titulo, contenido);
    }

    _limpiarFormulario();
    _refrescarNotas();
  }

  Future<void> _confirmarEliminar(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar esta nota permanentemente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DBNotas.eliminar(id);
              if (_idSeleccionado == id) _limpiarFormulario();
              _refrescarNotas();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas Local - Hola, $_nombreUsuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Preferencia Simple
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usuarioCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _guardarNombre,
                  tooltip: 'Guardar Preferencia',
                ),
              ],
            ),
            const Divider(height: 30),

            // Formulario CRUD Notas
            TextField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _contenidoCtrl,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _guardarOActualizar,
                    child: Text(_idSeleccionado == null ? 'Guardar Nota' : 'Actualizar Nota'),
                  ),
                ),
                if (_idSeleccionado != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _limpiarFormulario,
                    child: const Text('Cancelar'),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 16),

            // Lista de notas SQLite
            Expanded(
              child: _notas.isEmpty
                  ? const Center(child: Text('No hay notas guardadas.'))
                  : ListView.builder(
                      itemCount: _notas.length,
                      itemBuilder: (ctx, i) {
                        final item = _notas[i];
                        return Card(
                          child: ListTile(
                            title: Text(item['titulo']),
                            subtitle: Text(item['contenido']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarEliminar(item['id']),
                            ),
                            onTap: () {
                              setState(() {
                                _idSeleccionado = item['id'];
                                _tituloCtrl.text = item['titulo'];
                                _contenidoCtrl.text = item['contenido'];
                              });
                            },
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