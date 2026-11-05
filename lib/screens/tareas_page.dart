import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db.dart';
import '../models/tarea.dart';
import 'tarea_form.dart';

enum FiltroTareas { todas, pendientes, completadas }

class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  static const _claveNombre = 'nombre_usuario';
  static const _claveFiltro = 'filtro_tareas';

  final List<Tarea> _tareas = [];
  bool _cargando = true;
  String _nombre = 'Invitado';
  FiltroTareas _filtro = FiltroTareas.todas;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
    _cargarTareas();
  }

  // ---------- Preferencias ----------
  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombre = prefs.getString(_claveNombre) ?? 'Invitado';
      final f = prefs.getString(_claveFiltro);
      _filtro = FiltroTareas.values.firstWhere(
        (e) => e.name == f,
        orElse: () => FiltroTareas.todas,
      );
    });
  }

  Future<void> _guardarNombre(String n) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveNombre, n);
    setState(() => _nombre = n);
  }

  Future<void> _guardarFiltro(FiltroTareas f) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveFiltro, f.name);
    setState(() => _filtro = f);
  }

  // ---------- CRUD ----------
  Future<void> _cargarTareas() async {
    setState(() => _cargando = true);
    final lista = await DB.listar();
    setState(() {
      _tareas
        ..clear()
        ..addAll(lista);
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Tarea? tarea}) async {
    final resultado = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => TareaForm(tarea: tarea)),
    );
    if (resultado == null) return;
    if (resultado.id == null) {
      await DB.insertar(resultado);
    } else {
      await DB.actualizar(resultado);
    }
    await _cargarTareas();
  }

  Future<void> _toggleCompletada(Tarea t) async {
    await DB.actualizar(t.copyWith(
      completada: !t.completada,
      pendienteSincronizar: 1,
    ));
    await _cargarTareas();
  }

  Future<void> _eliminar(Tarea t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Eliminar tarea'),
        content: Text('¿Seguro que quieres eliminar "${t.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DB.eliminar(t.id!);
      await _cargarTareas();
    }
  }

  List<Tarea> get _filtradas {
    switch (_filtro) {
      case FiltroTareas.pendientes:
        return _tareas.where((t) => !t.completada).toList();
      case FiltroTareas.completadas:
        return _tareas.where((t) => t.completada).toList();
      case FiltroTareas.todas:
        return _tareas;
    }
  }

  // ---------- UI ----------
  void _editarNombre() {
    final ctrl = TextEditingController(text: _nombre);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('¿Cómo te llamas?'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final n = ctrl.text.trim();
              Navigator.pop(context);
              if (n.isNotEmpty) _guardarNombre(n);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = _tareas.length;
    final hechas = _tareas.where((t) => t.completada).length;
    final progreso = total == 0 ? 0.0 : hechas / total;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hola, $_nombre 👋',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _filtro == FiltroTareas.todas
                  ? 'Organiza tu día'
                  : 'Filtro: ${_filtro.name}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar nombre',
            onPressed: _editarNombre,
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _HeaderCard(progreso: progreso, total: total, hechas: hechas),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<FiltroTareas>(
              style: SegmentedButton.styleFrom(
                backgroundColor: Colors.white,
                selectedBackgroundColor:
                    theme.colorScheme.primary.withOpacity(0.12),
                selectedForegroundColor: theme.colorScheme.primary,
                side: BorderSide(color: Colors.grey.shade300),
              ),
              segments: const [
                ButtonSegment(
                  value: FiltroTareas.todas,
                  label: Text('Todas'),
                  icon: Icon(Icons.list_alt),
                ),
                ButtonSegment(
                  value: FiltroTareas.pendientes,
                  label: Text('Pendientes'),
                  icon: Icon(Icons.radio_button_unchecked),
                ),
                ButtonSegment(
                  value: FiltroTareas.completadas,
                  label: Text('Hechas'),
                  icon: Icon(Icons.check_circle_outline),
                ),
              ],
              selected: {_filtro},
              onSelectionChanged: (s) => _guardarFiltro(s.first),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildLista(theme)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  Widget _buildLista(ThemeData theme) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final items = _filtradas;
    if (items.isEmpty) {
      return _EstadoVacio(filtro: _filtro);
    }
    return RefreshIndicator(
      onRefresh: _cargarTareas,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final t = items[i];
          return _TareaCard(
            tarea: t,
            onToggle: () => _toggleCompletada(t),
            onEditar: () => _abrirFormulario(tarea: t),
            onEliminar: () => _eliminar(t),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets auxiliares
// ---------------------------------------------------------------------------

class _HeaderCard extends StatelessWidget {
  final double progreso;
  final int total;
  final int hechas;

  const _HeaderCard({
    required this.progreso,
    required this.total,
    required this.hechas,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.white, size: 26),
              const SizedBox(width: 8),
              Text(
                'Tu progreso',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$hechas/$total',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'Crea tu primera tarea para comenzar'
                : '¡Vas ${(progreso * 100).round()}% del camino!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _TareaCard extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onToggle;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _TareaCard({
    required this.tarea,
    required this.onToggle,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hecha = tarea.completada;

    return Dismissible(
      key: ValueKey(tarea.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onEliminar(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onEditar,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: hecha
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: hecha
                            ? theme.colorScheme.primary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: hecha
                        ? const Icon(Icons.check,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tarea.titulo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: hecha
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: hecha ? Colors.grey : null,
                              ),
                            ),
                          ),
                          if (tarea.pendienteSincronizar == 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(Icons.cloud_off,
                                  size: 16, color: Colors.orange.shade600),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tarea.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          decoration: hecha
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar',
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red.shade400),
                  onPressed: onEliminar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  final FiltroTareas filtro;
  const _EstadoVacio({required this.filtro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icono, titulo, sub) = switch (filtro) {
      FiltroTareas.todas => (
          Icons.note_add_outlined,
          'Aún no hay tareas',
          'Toca "Nueva tarea" para comenzar'
        ),
      FiltroTareas.pendientes => (
          Icons.celebration_outlined,
          '¡Todo hecho!',
          'No tienes tareas pendientes'
        ),
      FiltroTareas.completadas => (
          Icons.hourglass_empty,
          'Sin completadas',
          'Marca una tarea como hecha'
        ),
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icono,
                size: 56, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(titulo,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(sub,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}