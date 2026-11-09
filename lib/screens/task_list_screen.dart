import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_header.dart';
import '../widgets/add_task_button.dart';
import '../widgets/empty_state.dart';
import '../theme/app_theme.dart';

enum _Filter { all, pending, done }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  _Filter _filter = _Filter.all;

  Future<void> _showAddSheet(BuildContext context) async {
  final controller = TextEditingController();
  final provider = context.read<TaskProvider>(); // ✅ antes del await

  final title = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nueva tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: '¿Qué necesitas hacer?',
              ),
              onSubmitted: (v) => Navigator.pop(context, v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Añadir tarea'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  if (title != null) {
    provider.add(title); // ✅ ya no usa context
  }
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final all = provider.tasks;

    final visible = switch (_filter) {
      _Filter.all => all,
      _Filter.pending => all.where((t) => !t.completed).toList(),
      _Filter.done => all.where((t) => t.completed).toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: AddTaskButton(
        onPressed: () => _showAddSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          TaskHeader(pending: provider.pendingCount, total: all.length),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todas',
                  selected: _filter == _Filter.all,
                  onTap: () => setState(() => _filter = _Filter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pendientes',
                  selected: _filter == _Filter.pending,
                  onTap: () => setState(() => _filter = _Filter.pending),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Hechas',
                  selected: _filter == _Filter.done,
                  onTap: () => setState(() => _filter = _Filter.done),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: visible.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 120),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final task = visible[index];
                      return TweenAnimationBuilder<double>(
                        key: ValueKey(task.id),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(
                          milliseconds: 220 + (index * 40).clamp(0, 300),
                        ),
                        curve: Curves.easeOut,
                        builder: (_, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: TaskCard(
                          task: task,
                          onToggle: (id) =>
                              context.read<TaskProvider>().toggle(id),
                          onDelete: (id) =>
                              context.read<TaskProvider>().remove(id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textSoft,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}