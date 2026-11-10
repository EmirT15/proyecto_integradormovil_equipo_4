import 'package:flutter/material.dart';
import '../models/punto_interes_model.dart';

class PoiCard extends StatelessWidget {
  final PuntoInteresModel poi;
  final double? distanciaMetros;
  final void Function(double latitud, double longitud)? onAbrirNavegacion;

  const PoiCard({
    super.key,
    required this.poi,
    required this.distanciaMetros,
    this.onAbrirNavegacion,
  });

  void abrirNavegacion(double latitud, double longitud) {
    onAbrirNavegacion?.call(latitud, longitud);
  }

  String _formatearDistancia(double metros) {
    if (metros >= 1000) {
      return '${(metros / 1000).toStringAsFixed(2)} km';
    }
    return '${metros.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.place, color: Color(0xFF00E5FF)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    poi.descripcion,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.straighten, size: 14, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(
                        distanciaMetros != null
                            ? 'Distancia: ${_formatearDistancia(distanciaMetros!)}'
                            : 'Distancia: N/A',
                        style: TextStyle(
                          color: distanciaMetros != null
                              ? const Color(0xFF69F0AE)
                              : Colors.white38,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.directions, color: Color(0xFF00E5FF)),
              onPressed: () {
                abrirNavegacion(poi.latitud, poi.longitud);
              },
            ),
          ],
        ),
      ),
    );
  }
}