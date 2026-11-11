import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';

class BotonesContadorWidget extends StatelessWidget {
  const BotonesContadorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContadorProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => provider.incrementar(),
          icon: const Icon(Icons.add),
          label: const Text('Incrementar'),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => provider.reiniciar(),
          icon: const Icon(Icons.refresh),
          label: const Text('Reiniciar'),
        ),
      ],
    );
  }
}