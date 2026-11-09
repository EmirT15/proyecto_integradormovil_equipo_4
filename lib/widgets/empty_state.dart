import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.task_alt, size: 52, color: AppTheme.primary),
          ),
          const SizedBox(height: 18),
          const Text(
            'Todo al día ✨',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pulsa "Nueva tarea" para empezar',
            style: TextStyle(color: AppTheme.textSoft),
          ),
        ],
      ),
    );
  }
}