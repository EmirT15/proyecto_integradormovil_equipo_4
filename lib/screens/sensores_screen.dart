import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  XFile? foto;
  double x = 0, y = 0, z = 0;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  @override
  void initState() {
    super.initState();
    _accelSubscription = accelerometerEventStream().listen((event) {
      if (mounted) {
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    super.dispose();
  }

  Future<void> tomarFoto() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (f != null && mounted) {
        setState(() => foto = f);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al acceder a la cámara: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y Acelerómetro'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FilledButton.icon(
            onPressed: tomarFoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar fotografía'),
          ),
          const SizedBox(height: 12),
          if (foto != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(foto!.path),
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Acelerómetro X: ${x.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Acelerómetro Y: ${y.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Acelerómetro Z: ${z.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}