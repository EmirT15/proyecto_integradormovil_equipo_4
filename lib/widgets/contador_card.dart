import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContadorCard extends StatelessWidget {
  final int valor;
  final DateTime ultimaModificacion;

  const ContadorCard({
    super.key,
    required this.valor,
    required this.ultimaModificacion,
  });

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat('HH:mm:ss').format(ultimaModificacion);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Valor del Contador',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              '$valor',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Último cambio: $fechaFormateada',
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}