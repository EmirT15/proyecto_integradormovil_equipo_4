import 'package:flutter/foundation.dart';
import '../models/tarea_model.dart';

class TareaProvider extends ChangeNotifier {
  final List<TareaModel> _tareas = [
    TareaModel(
      id: '1',
      titulo: 'Refactorizar arquitectura Flutter',
      categoria: 'Móvil',
      fecha: DateTime.now(),
      prioridad: 'Alta',
    ),
    TareaModel(
      id: '2',
      titulo: 'Diseñar Dashboard Neumórfico',
      categoria: 'UI/UX',
      fecha: DateTime.now().add(const Duration(hours: 2)),
      prioridad: 'Media',
    ),
  ];

  String _filtroCategoria = 'Todas';

  List<TareaModel> get tareas {
    if (_filtroCategoria == 'Todas') return List.unmodifiable(_tareas);
    return List.unmodifiable(
      _tareas.where((t) => t.categoria == _filtroCategoria),
    );
  }

  String get filtroCategoria => _filtroCategoria;

  double get porcentajeCompletado {
    if (_tareas.isEmpty) return 0.0;
    final completadas = _tareas.where((t) => t.completada).length;
    return completadas / _tareas.length;
  }

  void cambiarFiltro(String nuevaCategoria) {
    _filtroCategoria = nuevaCategoria;
    notifyListeners();
  }

  void alternarEstado(String id) {
    final index = _tareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tareas[index] = _tareas[index].copyWith(
        completada: !_tareas[index].completada,
      );
      notifyListeners();
    }
  }

  void agregarTarea(TareaModel tarea) {
    _tareas.insert(0, tarea);
    notifyListeners();
  }

  void eliminarTarea(String id) {
    _tareas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}