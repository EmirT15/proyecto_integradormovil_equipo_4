import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import '../services/tarea_service.dart';
import '../models/tarea.dart';
import 'notas_page.dart';
import 'tareas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nombre = 'Invitado';
  List<Tarea> tareas = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final usuario = await PreferencesService.leerNombre();
    final lista = await TareaService.listar();

    if (!mounted) return;

    setState(() {
      nombre = usuario;
      tareas = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = tareas.where((t) => !t.completada).length;
    final completadas = tareas.where((t) => t.completada).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor Offline'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: mostrarConfiguracion,
            icon: const Icon(Icons.person),
            tooltip: 'Configuración del usuario',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: cargarDatos,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '¡Hola, $nombre!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Organiza tus notas y actividades.'),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: tarjetaResumen(
                    'Pendientes',
                    pendientes.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: tarjetaResumen(
                    'Completadas',
                    completadas.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Mis herramientas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.note_alt,
                  color: Colors.green,
                  size: 35,
                ),
                title: const Text('Mis notas'),
                subtitle: const Text('Crear y administrar notas'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotasPage()),
                  );
                  cargarDatos();
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.task_alt,
                  color: Colors.green,
                  size: 35,
                ),
                title: const Text('Mis tareas'),
                subtitle: const Text('Organizar actividades pendientes'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TareasPage()),
                  );
                  cargarDatos();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjetaResumen(
    String titulo,
    String cantidad,
    IconData icono,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icono, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              cantidad,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(titulo),
          ],
        ),
      ),
    );
  }

  Future<void> mostrarConfiguracion() async {
    final controller = TextEditingController(text: nombre);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nombre de usuario'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Escribe tu nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoNombre = controller.text.trim();

              if (nuevoNombre.isEmpty) return;

              await PreferencesService.guardarNombre(nuevoNombre);

              if (!mounted) return;

              setState(() {
                nombre = nuevoNombre;
              });

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    controller.dispose();
  }
}
