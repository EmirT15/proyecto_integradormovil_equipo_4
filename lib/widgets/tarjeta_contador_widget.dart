import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';

class TarjetaContadorWidget extends StatelessWidget {
  const TarjetaContadorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<ContadorProvider>().valor;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Valor del Contador:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '$contador',
              style: const TextStyle(fontSize: 48, color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}