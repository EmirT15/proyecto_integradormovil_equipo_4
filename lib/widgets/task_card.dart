import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';

class TaskCard extends StatelessWidget {
  final TareaModel tarea;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPrioridadColor(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return const Color(0xFFFF5252);
      case 'Media':
        return const Color(0xFFFFAB40);
      default:
        return const Color(0xFF69F0AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat('dd MMM, hh:mm a').format(tarea.fecha);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: tarea.completada
              ? Colors.greenAccent.withValues(alpha: 0.3)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              tarea.completada
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: tarea.completada ? Colors.greenAccent : Colors.grey,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarea.titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: tarea.completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getPrioridadColor(tarea.prioridad)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tarea.prioridad,
                        style: TextStyle(
                          color: _getPrioridadColor(tarea.prioridad),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fechaFormateada,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }
}