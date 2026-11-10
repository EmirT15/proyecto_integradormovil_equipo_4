import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationHeader extends StatelessWidget {
  final Position? posicion;
  final bool cargando;
  final VoidCallback onRefresh;

  const CurrentLocationHeader({
    super.key,
    required this.posicion,
    required this.cargando,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF00E5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.gps_fixed, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Mi GPS Actual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: cargando ? null : onRefresh,
                icon: cargando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (posicion != null) ...[
            Text(
              'Lat: ${posicion!.latitude.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              'Lng: ${posicion!.longitude.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Precisión: ±${posicion!.accuracy.toStringAsFixed(1)} metros',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ] else ...[
            const Text(
              'Presiona el botón para detectar tus coordenadas actuales',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}