import 'package:flutter/material.dart';
import '../services/sensor_service.dart';

class SensorLiveGauge extends StatelessWidget {
  final SensorData data;

  const SensorLiveGauge({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBB86FC).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sensors, color: Color(0xFFBB86FC)),
              SizedBox(width: 8),
              Text(
                'Telemetría en Tiempo Real',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSensorColumn(
                  'Acelerómetro (m/s²)',
                  Colors.cyanAccent,
                  data.accelX,
                  data.accelY,
                  data.accelZ,
                ),
              ),
              Container(height: 50, width: 1, color: Colors.white10),
              Expanded(
                child: _buildSensorColumn(
                  'Giroscopio (rad/s)',
                  Colors.amberAccent,
                  data.gyroX,
                  data.gyroY,
                  data.gyroZ,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorColumn(
    String titulo,
    Color color,
    double x,
    double y,
    double z,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('X: ${x.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text('Y: ${y.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text('Z: ${z.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}