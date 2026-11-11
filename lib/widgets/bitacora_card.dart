import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bitacora_model.dart';

class BitacoraCard extends StatelessWidget {
  final BitacoraModel registro;

  const BitacoraCard({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    final fechaFmt = DateFormat('dd/MM/yyyy • HH:mm:ss').format(registro.fechaHora);

    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment_turned_in, color: Color(0xFFBB86FC), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    registro.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  fechaFmt,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(registro.fotoPath),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 120,
                  color: Colors.white10,
                  child: const Center(
                    child: Text('Foto no disponible en este dispositivo', style: TextStyle(color: Colors.white38)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF12121C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Acelerómetro Congelado', style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('X: ${registro.accelX.toStringAsFixed(2)} | Y: ${registro.accelY.toStringAsFixed(2)} | Z: ${registro.accelZ.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Giroscopio Congelado', style: TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('X: ${registro.gyroX.toStringAsFixed(2)} | Y: ${registro.gyroY.toStringAsFixed(2)} | Z: ${registro.gyroZ.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}