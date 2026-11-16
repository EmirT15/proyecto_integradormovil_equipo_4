import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tarea_provider.dart';

class TareasPage extends StatelessWidget {
  const TareasPage({super.key});

  Future<void> _mostrarFormulario(BuildContext context, {Tarea? tarea}) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => FormularioTareaDialog(tarea: tarea),
    );
  }

  Future<void> _cambiarEstado(
    BuildContext context,
    Tarea tarea,
    bool valor,
  ) async {
    final provider = context.read<TareaProvider>();

    final actualizada = tarea.copyWith(
      completada: valor,
      pendienteSincronizar: true,
    );

    final resultado = await provider.actualizarTarea(actualizada);

    if (!context.mounted) return;

    if (!resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'No se pudo actualizar la tarea.'),
        ),
      );
    }
  }

  Future<void> _confirmarEliminar(BuildContext context, Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Deseas eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final provider = context.read<TareaProvider>();
    final eliminado = await provider.eliminarTarea(tarea.id!);

    if (!context.mounted) return;

    if (!eliminado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'No se pudo eliminar la tarea.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TareaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.tareas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.cargarTareas,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String>(
                  initialValue: provider.filtro,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar tareas',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Todas', child: Text('Todas')),
                    DropdownMenuItem(
                      value: 'Pendientes',
                      child: Text('Pendientes'),
                    ),
                    DropdownMenuItem(
                      value: 'Completadas',
                      child: Text('Completadas'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      provider.cambiarFiltro(valor);
                    }
                  },
                ),
              ),
              Expanded(
                child: provider.tareasFiltradas.isEmpty
                    ? const Center(child: Text('No hay tareas para mostrar'))
                    : ListView.builder(
                        itemCount: provider.tareasFiltradas.length,
                        itemBuilder: (context, index) {
                          final tarea = provider.tareasFiltradas[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: tarea.completada,
                                onChanged: (valor) {
                                  if (valor != null) {
                                    _cambiarEstado(context, tarea, valor);
                                  }
                                },
                              ),
                              title: Text(
                                tarea.titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: tarea.completada
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tarea.descripcion),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        tarea.pendienteSincronizar
                                            ? Icons.cloud_upload_outlined
                                            : Icons.cloud_done,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        tarea.pendienteSincronizar
                                            ? 'Pendiente de sincronizar'
                                            : 'Sincronizada',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (valor) {
                                  if (valor == 'editar') {
                                    _mostrarFormulario(context, tarea: tarea);
                                  } else if (valor == 'eliminar') {
                                    _confirmarEliminar(context, tarea);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'editar',
                                    child: Text('Editar'),
                                  ),
                                  PopupMenuItem(
                                    value: 'eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormularioTareaDialog extends StatefulWidget {
  final Tarea? tarea;

  const FormularioTareaDialog({super.key, this.tarea});

  @override
  State<FormularioTareaDialog> createState() => _FormularioTareaDialogState();
}

class _FormularioTareaDialogState extends State<FormularioTareaDialog> {
  final _formularioKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(text: widget.tarea?.titulo ?? '');

    _descripcionController = TextEditingController(
      text: widget.tarea?.descripcion ?? '',
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarTarea() async {
    if (!_formularioKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final nuevaTarea = Tarea(
      id: widget.tarea?.id,
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      completada: widget.tarea?.completada ?? false,
      pendienteSincronizar: true,
    );

    final provider = context.read<TareaProvider>();

    final guardada = widget.tarea == null
        ? await provider.agregarTarea(nuevaTarea)
        : await provider.actualizarTarea(nuevaTarea);

    if (!mounted) return;

    if (guardada) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'No se pudo guardar la tarea.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tarea == null ? 'Nueva tarea' : 'Editar tarea'),
      content: Form(
        key: _formularioKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                enabled: !_guardando,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Escribe un título';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descripcionController,
                enabled: !_guardando,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Escribe una descripción';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _guardando ? null : _guardarTarea,
          icon: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_guardando ? 'Guardando...' : 'Guardar'),
        ),
      ],
    );
  }
}
