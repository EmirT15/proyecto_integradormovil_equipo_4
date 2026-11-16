import 'dart:io';
import 'package:flutter/material.dart';
import '../models/incidencia_model.dart';

class DetalleReporteScreen extends StatelessWidget {
  final IncidenciaModel reporte;

  const DetalleReporteScreen({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(reporte.titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (reporte.fotoPath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(reporte.fotoPath), height: 220, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text('Categoría: ${reporte.categoria}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(reporte.descripcion, style: const TextStyle(fontSize: 16)),
          const Divider(height: 32),
          Text('Fecha: ${reporte.fechaHora.toString().split('.')[0]}'),
          Text('Latitud: ${reporte.latitud}'),
          Text('Longitud: ${reporte.longitud}'),
        ],
      ),
    );
  }
}