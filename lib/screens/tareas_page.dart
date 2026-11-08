import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../services/tarea_service.dart';
import '../services/preferences_service.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  List<Tarea> tareas = [];
  String filtro = 'Todas';
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  // Consultar las tareas y recuperar el filtro guardado.
  Future<void> cargarDatos() async {
    final resultado = await TareaService.listar();
    final filtroGuardado = await PreferencesService.leerFiltro();

    if (!mounted) return;

    setState(() {
      tareas = resultado;
      filtro = filtroGuardado;
      cargando = false;
    });
  }

  // Crear o editar una tarea.
  Future<void> mostrarFormulario({Tarea? tarea}) async {
    final tituloController = TextEditingController(text: tarea?.titulo ?? '');

    final descripcionController = TextEditingController(
      text: tarea?.descripcion ?? '',
    );

    final formularioKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tarea == null ? 'Nueva tarea' : 'Editar tarea'),
        content: Form(
          key: formularioKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tituloController,
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
                  controller: descripcionController,
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            onPressed: () async {
              if (!formularioKey.currentState!.validate()) {
                return;
              }

              final nuevaTarea = Tarea(
                id: tarea?.id,
                titulo: tituloController.text.trim(),
                descripcion: descripcionController.text.trim(),
                completada: tarea?.completada ?? false,
                pendienteSincronizar: true,
              );

              if (tarea == null) {
                await TareaService.insertar(nuevaTarea);
              } else {
                await TareaService.actualizar(nuevaTarea);
              }

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
          ),
        ],
      ),
    );

    tituloController.dispose();
    descripcionController.dispose();

    if (mounted) {
      await cargarDatos();
    }
  }

  // Cambiar el estado de una tarea.
  Future<void> cambiarEstado(Tarea tarea, bool valor) async {
    final tareaActualizada = tarea.copyWith(
      completada: valor,
      pendienteSincronizar: true,
    );

    await TareaService.actualizar(tareaActualizada);
    await cargarDatos();
  }

  // Eliminar una tarea con confirmación.
  Future<void> confirmarEliminar(Tarea tarea) async {
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

    if (confirmar == true) {
      await TareaService.eliminar(tarea.id!);
      await cargarDatos();
    }
  }

  // Guardar el filtro seleccionado.
  Future<void> cambiarFiltro(String nuevoFiltro) async {
    await PreferencesService.guardarFiltro(nuevoFiltro);

    if (!mounted) return;

    setState(() {
      filtro = nuevoFiltro;
    });
  }

  // Aplicar el filtro.
  List<Tarea> get tareasFiltradas {
    if (filtro == 'Pendientes') {
      return tareas.where((t) => !t.completada).toList();
    }

    if (filtro == 'Completadas') {
      return tareas.where((t) => t.completada).toList();
    }

    return tareas;
  }

  @override
  Widget build(BuildContext context) {
    final lista = tareasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField<String>(
                    initialValue: filtro,
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
                        cambiarFiltro(valor);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: lista.isEmpty
                      ? const Center(child: Text('No hay tareas para mostrar'))
                      : ListView.builder(
                          itemCount: lista.length,
                          itemBuilder: (context, index) {
                            final tarea = lista[index];

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
                                      cambiarEstado(tarea, valor);
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
                                      mostrarFormulario(tarea: tarea);
                                    } else if (valor == 'eliminar') {
                                      confirmarEliminar(tarea);
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
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () => mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
