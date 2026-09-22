import 'package:flutter/material.dart';

import '../models/materia.dart';

class MateriaDetallePage extends StatelessWidget {
  final Materia materia;

  const MateriaDetallePage({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(materia.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.school,
                size: 90,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              materia.nombre,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(label: Text('Semestre: ${materia.semestre}°')),
                const SizedBox(width: 10),
                Chip(label: Text('Créditos: ${materia.creditos}')),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Descripción de la materia:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              materia.descripcion,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
