import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service;

  TaskProvider(this._service) {
    _tasks = _service.fetchAll();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);
  int get pendingCount => _tasks.where((t) => !t.completed).length;

  void add(String title) {
    if (title.trim().isEmpty) return;
    _service.create(title.trim());
    _tasks = _service.fetchAll();
    notifyListeners();
  }

  void toggle(String id) {
    _service.toggle(id);
    _tasks = _service.fetchAll();
    notifyListeners();
  }

  void remove(String id) {
    _service.delete(id);
    _tasks = _service.fetchAll();
    notifyListeners();
  }
}