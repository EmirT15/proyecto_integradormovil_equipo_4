import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_7/providers/task_provider.dart';
import 'package:flutter_application_7/services/task_service.dart';

void main() {
  test('agrega, completa y elimina tareas', () {
    final provider = TaskProvider(TaskService());

    provider.add('Comprar pan');
    expect(provider.tasks.length, 1);
    expect(provider.pendingCount, 1);

    provider.toggle(provider.tasks.first.id);
    expect(provider.pendingCount, 0);

    provider.remove(provider.tasks.first.id);
    expect(provider.tasks.isEmpty, true);
  });
}