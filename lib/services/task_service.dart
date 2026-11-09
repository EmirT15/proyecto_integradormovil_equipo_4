import 'package:uuid/uuid.dart';
import '../models/task.dart';

/// Servicio de datos. Simula una fuente externa (API/DB).
/// Separar el servicio permite sustituirlo por uno real sin tocar la UI.
class TaskService {
  final Uuid _uuid = const Uuid();
  final List<Task> _store = [];

  List<Task> fetchAll() => List.unmodifiable(_store);

  Task create(String title) {
    final task = Task(id: _uuid.v4(), title: title);
    _store.add(task);
    return task;
  }

  Task toggle(String id) {
    final index = _store.indexWhere((t) => t.id == id);
    final updated = _store[index].copyWith(completed: !_store[index].completed);
    _store[index] = updated;
    return updated;
  }

  void delete(String id) => _store.removeWhere((t) => t.id == id);
}