import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/tarea_service.dart';
import '../services/preferences_service.dart';

class TareaProvider extends ChangeNotifier {
  List<Tarea> _tareas = [];
  bool _isLoading = false;
  String? _error;
  String _filtro = 'Todas';

  List<Tarea> get tareas => List.unmodifiable(_tareas);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filtro => _filtro;

  List<Tarea> get tareasFiltradas {
    switch (_filtro) {
      case 'Pendientes':
        return _tareas.where((tarea) => !tarea.completada).toList();
      case 'Completadas':
        return _tareas.where((tarea) => tarea.completada).toList();
      default:
        return _tareas;
    }
  }

  int get cantidadPendientes =>
      _tareas.where((tarea) => !tarea.completada).length;

  int get cantidadCompletadas =>
      _tareas.where((tarea) => tarea.completada).length;

  Future<void> cargarTareas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tareas = await TareaService.listar();
      _filtro = await PreferencesService.leerFiltro();
    } catch (e) {
      _error = 'No se pudieron cargar las tareas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarTarea(Tarea tarea) async {
    try {
      await TareaService.insertar(tarea);
      await cargarTareas();
      return true;
    } catch (e) {
      _error = 'No se pudo agregar la tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarTarea(Tarea tarea) async {
    try {
      await TareaService.actualizar(tarea);
      await cargarTareas();
      return true;
    } catch (e) {
      _error = 'No se pudo actualizar la tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarTarea(int id) async {
    try {
      await TareaService.eliminar(id);
      await cargarTareas();
      return true;
    } catch (e) {
      _error = 'No se pudo eliminar la tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> cambiarFiltro(String nuevoFiltro) async {
    _filtro = nuevoFiltro;
    notifyListeners();

    try {
      await PreferencesService.guardarFiltro(nuevoFiltro);
    } catch (e) {
      _error = 'No se pudo guardar el filtro: $e';
      notifyListeners();
    }
  }
}
