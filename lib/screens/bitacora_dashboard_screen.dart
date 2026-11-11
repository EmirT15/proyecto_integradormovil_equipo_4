import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/bitacora_model.dart';
import '../services/sensor_service.dart';
import '../widgets/bitacora_card.dart';
import '../widgets/sensor_live_gauge.dart';

class BitacoraDashboardScreen extends StatefulWidget {
  const BitacoraDashboardScreen({super.key});

  @override
  State<BitacoraDashboardScreen> createState() => _BitacoraDashboardScreenState();
}

class _BitacoraDashboardScreenState extends State<BitacoraDashboardScreen> {
  final SensorService _sensorService = SensorService();
  SensorData _currentSensorData = const SensorData();
  final List<BitacoraModel> _registros = [];

  @override
  void initState() {
    super.initState();
    _sensorService.iniciarLectura((data) {
      if (mounted) {
        setState(() => _currentSensorData = data);
      }
    });
  }

  @override
  void dispose() {
    _sensorService.detener();
    super.dispose();
  }

  Future<void> _capturarInspeccion() async {
    final titleController = TextEditingController();

    try {
      final XFile? foto = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      // Manejo estricto de cancelación de cámara exigido por el manual
      if (foto == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Captura de inspección cancelada.')),
          );
        }
        return;
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Título de la Inspección', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Ej. Fuga en contenedor A-3',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBB86FC)),
              onPressed: () {
                final titulo = titleController.text.trim().isEmpty
                    ? 'Inspección #${_registros.length + 1}'
                    : titleController.text.trim();

                setState(() {
                  _registros.insert(
                    0,
                    BitacoraModel(
                      id: DateTime.now().toString(),
                      titulo: titulo,
                      fotoPath: foto.path,
                      fechaHora: DateTime.now(),
                      accelX: _currentSensorData.accelX,
                      accelY: _currentSensorData.accelY,
                      accelZ: _currentSensorData.accelZ,
                      gyroX: _currentSensorData.gyroX,
                      gyroY: _currentSensorData.gyroY,
                      gyroZ: _currentSensorData.gyroZ,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al capturar evidencia: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Inspección & Sensores'),
        backgroundColor: const Color(0xFF12121C),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SensorLiveGauge(data: _currentSensorData),
              const SizedBox(height: 20),
              const Text(
                'Registros de Evidencia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _registros.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay inspecciones registradas.\nPresiona el botón para tomar una evidencia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _registros.length,
                        itemBuilder: (context, index) {
                          return BitacoraCard(registro: _registros[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFBB86FC),
        foregroundColor: Colors.black,
        onPressed: _capturarInspeccion,
        icon: const Icon(Icons.photo_camera),
        label: const Text('Nueva Inspección', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}