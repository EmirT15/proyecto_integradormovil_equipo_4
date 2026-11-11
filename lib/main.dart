import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SensoresPageGuiada(),
  ));
}

class SensoresPageGuiada extends StatefulWidget {
  const SensoresPageGuiada({super.key});

  @override
  State<SensoresPageGuiada> createState() => _SensoresPageGuiadaState();
}

class _SensoresPageGuiadaState extends State<SensoresPageGuiada> {
  XFile? foto;
  double x = 0, y = 0, z = 0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;

  @override
  void initState() {
    super.initState();
    _accelerometerSub = accelerometerEventStream().listen((e) {
      if (mounted) {
        setState(() {
          x = e.x;
          y = e.y;
          z = e.z;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSub?.cancel();
    super.dispose();
  }

  Future<void> tomarFoto() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (f != null) {
        setState(() => foto = f);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error o permisos no otorgados: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara y Acelerómetro - JuanPablo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FilledButton.icon(
            onPressed: tomarFoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar fotografía'),
          ),
          const SizedBox(height: 12),
          if (foto != null)
            Image.file(File(foto!.path), height: 250, fit: BoxFit.cover)
          else
            const Center(child: Text('Sin foto seleccionada')),
          const Divider(height: 30),
          Text('Acelerómetro X: ${x.toStringAsFixed(2)}'),
          Text('Acelerómetro Y: ${y.toStringAsFixed(2)}'),
          Text('Acelerómetro Z: ${z.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}