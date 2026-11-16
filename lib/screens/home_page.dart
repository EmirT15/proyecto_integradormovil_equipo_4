import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/nota_provider.dart';
import '../providers/tarea_provider.dart';
import '../providers/usuario_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/summary_card.dart';
import '../widgets/tool_card.dart';
import 'notas_page.dart';
import 'tareas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _cargarDatos(BuildContext context) async {
    await Future.wait([
      context.read<TareaProvider>().cargarTareas(),
      context.read<UsuarioProvider>().cargarNombre(),
    ]);
  }

  Future<void> _mostrarConfiguracion(BuildContext context) async {
    final usuarioProvider = context.read<UsuarioProvider>();

    final nuevoNombre = await showDialog<String>(
      context: context,
      builder: (_) =>
          ConfiguracionUsuarioDialog(nombre: usuarioProvider.nombre),
    );

    if (!context.mounted || nuevoNombre == null) return;

    final actualizado = await usuarioProvider.actualizarNombre(nuevoNombre);

    if (!context.mounted) return;

    if (!actualizado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            usuarioProvider.error ?? 'No se pudo actualizar el nombre.',
          ),
        ),
      );
    }
  }

  Future<void> _abrirNotas(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotasPage()),
    );

    if (!context.mounted) return;

    await context.read<NotaProvider>().cargarNotas();
  }

  Future<void> _abrirTareas(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TareasPage()),
    );

    if (!context.mounted) return;

    await context.read<TareaProvider>().cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    final nombre = context.select<UsuarioProvider, String>(
      (provider) => provider.nombre,
    );

    final pendientes = context.select<TareaProvider, int>(
      (provider) => provider.cantidadPendientes,
    );

    final completadas = context.select<TareaProvider, int>(
      (provider) => provider.cantidadCompletadas,
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text(
          'Gestor Offline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _mostrarConfiguracion(context),
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Configuración del usuario',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _cargarDatos(context),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.78),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.waving_hand_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '¡Hola, $nombre!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Organiza tus ideas y actividades del día.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const SectionTitle(
              title: 'Resumen de actividades',
              subtitle: 'Consulta el estado de tus tareas.',
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Pendientes',
                    value: pendientes.toString(),
                    icon: Icons.pending_actions_rounded,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Completadas',
                    value: completadas.toString(),
                    icon: Icons.task_alt_rounded,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const SectionTitle(
              title: 'Mis herramientas',
              subtitle: 'Selecciona lo que deseas administrar.',
            ),

            const SizedBox(height: 14),

            ToolCard(
              title: 'Mis notas',
              description: 'Crea y administra tus notas personales.',
              icon: Icons.note_alt_rounded,
              onTap: () => _abrirNotas(context),
            ),

            ToolCard(
              title: 'Mis tareas',
              description: 'Organiza y completa tus actividades.',
              icon: Icons.checklist_rounded,
              onTap: () => _abrirTareas(context),
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                'Tus datos están disponibles sin conexión.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfiguracionUsuarioDialog extends StatefulWidget {
  final String nombre;

  const ConfiguracionUsuarioDialog({super.key, required this.nombre});

  @override
  State<ConfiguracionUsuarioDialog> createState() =>
      _ConfiguracionUsuarioDialogState();
}

class _ConfiguracionUsuarioDialogState
    extends State<ConfiguracionUsuarioDialog> {
  late final TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardarNombre() {
    final nuevoNombre = _nombreController.text.trim();

    if (nuevoNombre.isEmpty) return;

    Navigator.of(context).pop(nuevoNombre);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre de usuario'),
      content: TextField(
        controller: _nombreController,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Escribe tu nombre',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _guardarNombre(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _guardarNombre, child: const Text('Guardar')),
      ],
    );
  }
}
