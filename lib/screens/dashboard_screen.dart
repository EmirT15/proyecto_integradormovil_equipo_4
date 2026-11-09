import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tarea_model.dart';
import '../providers/tarea_provider.dart';
import '../widgets/category_filter_chip.dart';
import '../widgets/progress_header_card.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _mostrarDialogoNuevaTarea(BuildContext context) {
    final controller = TextEditingController();
    String prioridadSeleccionada = 'Media';
    String categoriaSeleccionada = 'Móvil';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nueva Tarea',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Título de la tarea...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF12121C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DropdownButton<String>(
                    value: prioridadSeleccionada,
                    dropdownColor: const Color(0xFF1E1E2C),
                    style: const TextStyle(color: Colors.white),
                    items: ['Alta', 'Media', 'Baja'].map((p) {
                      return DropdownMenuItem(value: p, child: Text('Prioridad: $p'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => prioridadSeleccionada = val);
                    },
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: categoriaSeleccionada,
                    dropdownColor: const Color(0xFF1E1E2C),
                    style: const TextStyle(color: Colors.white),
                    items: ['Móvil', 'UI/UX', 'General'].map((c) {
                      return DropdownMenuItem(value: c, child: Text('Cat: $c'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => categoriaSeleccionada = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BFFFF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      final nueva = TareaModel(
                        id: DateTime.now().toString(),
                        titulo: controller.text.trim(),
                        categoria: categoriaSeleccionada,
                        fecha: DateTime.now(),
                        prioridad: prioridadSeleccionada,
                      );
                      Provider.of<TareaProvider>(context, listen: false).agregarTarea(nueva);
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Agregar Tarea', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Todas', 'Móvil', 'UI/UX', 'General'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard de Tareas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Consumer<TareaProvider>(
                builder: (context, provider, _) => ProgressHeaderCard(
                  porcentaje: provider.porcentajeCompletado,
                  totalTareas: provider.tareas.length,
                ),
              ),
              const SizedBox(height: 20),
              Consumer<TareaProvider>(
                builder: (context, provider, _) => SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final cat = categorias[index];
                      return CategoryFilterChip(
                        label: cat,
                        isSelected: provider.filtroCategoria == cat,
                        onTap: () => provider.cambiarFiltro(cat),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<TareaProvider>(
                  builder: (context, provider, _) {
                    final tareas = provider.tareas;
                    if (tareas.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay tareas en esta categoría',
                          style: TextStyle(color: Colors.white38),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = tareas[index];
                        return TaskCard(
                          tarea: tarea,
                          onToggle: () => provider.alternarEstado(tarea.id),
                          onDelete: () => provider.eliminarTarea(tarea.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1BFFFF),
        foregroundColor: Colors.black,
        onPressed: () => _mostrarDialogoNuevaTarea(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}