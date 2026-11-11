import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAppBitacora());
}

class MiAppBitacora extends StatelessWidget {
  const MiAppBitacora({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitácora de Inspección - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BitacoraScreen(),
    );
  }
}

class RegistroEvidencia {
  final String id;
  final String rutaFoto;
  final DateTime fechaHora;
  final double accelX, accelY, accelZ;
  final double gyroX, gyroY, gyroZ;
  final String notas;

  RegistroEvidencia({
    required this.id,
    required this.rutaFoto,
    required this.fechaHora,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.notas,
  });
}

class BitacoraScreen extends StatefulWidget {
  const BitacoraScreen({super.key});

  @override
  State<BitacoraScreen> createState() => _BitacoraScreenState();
}

class _BitacoraScreenState extends State<BitacoraScreen> {
  // Sensores
  double _ax = 0, _ay = 0, _az = 0;
  double _gx = 0, _gy = 0, _gz = 0;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  final List<RegistroEvidencia> _bitacora = [];

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEventStream().listen((e) {
      if (mounted) setState(() { _ax = e.x; _ay = e.y; _az = e.z; });
    });
    _gyroSub = gyroscopeEventStream().listen((e) {
      if (mounted) setState(() { _gx = e.x; _gy = e.y; _gz = e.z; });
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  Future<void> _capturarEvidencia() async {
    final picker = ImagePicker();
    XFile? fotoCapturada;
    
    try {
      fotoCapturada = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al acceder a la cámara o permisos: $e')),
        );
      }
      return;
    }

    // Manejo explicito de cancelación
    if (fotoCapturada == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Captura cancelada por el usuario.')),
        );
      }
      return;
    }

    final notasCtrl = TextEditingController();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar Notas a Evidencia'),
        content: TextField(
          controller: notasCtrl,
          decoration: const InputDecoration(labelText: 'Detalles de la inspección'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoRegistro = RegistroEvidencia(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                rutaFoto: fotoCapturada!.path,
                fechaHora: DateTime.now(),
                accelX: _ax,
                accelY: _ay,
                accelZ: _az,
                gyroX: _gx,
                gyroY: _gy,
                gyroZ: _gz,
                notas: notasCtrl.text.trim().isEmpty ? 'Sin notas' : notasCtrl.text.trim(),
              );

              setState(() {
                _bitacora.insert(0, nuevoRegistro);
              });

              Navigator.pop(context);
            },
            child: const Text('Guardar Evidencia'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatoFecha = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora Multimedia - JuanPablo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Monitor en tiempo real de sensores
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('Estado de Sensores en Vivo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Acelerómetro', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo)),
                          Text('X: ${_ax.toStringAsFixed(2)}'),
                          Text('Y: ${_ay.toStringAsFixed(2)}'),
                          Text('Z: ${_az.toStringAsFixed(2)}'),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Giroscopio', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
                          Text('X: ${_gx.toStringAsFixed(2)}'),
                          Text('Y: ${_gy.toStringAsFixed(2)}'),
                          Text('Z: ${_gz.toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Registros de Inspección:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: _bitacora.isEmpty
                ? const Center(child: Text('No hay evidencias registradas en la bitácora.'))
                : ListView.builder(
                    itemCount: _bitacora.length,
                    itemBuilder: (context, index) {
                      final item = _bitacora[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18),
                                  const SizedBox(width: 6),
                                  Text(formatoFecha.format(item.fechaHora), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(item.rutaFoto),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 100,
                                    color: Colors.grey,
                                    child: Center(child: Text('Imagen no encontrada (Escritorio)')),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Notas: ${item.notas}', style: const TextStyle(fontStyle: FontStyle.italic)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Acelerómetro: [X: ${item.accelX.toStringAsFixed(2)}, Y: ${item.accelY.toStringAsFixed(2)}, Z: ${item.accelZ.toStringAsFixed(2)}]\n'
                                  'Giroscopio: [X: ${item.gyroX.toStringAsFixed(2)}, Y: ${item.gyroY.toStringAsFixed(2)}, Z: ${item.gyroZ.toStringAsFixed(2)}]',
                                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _capturarEvidencia,
        icon: const Icon(Icons.camera),
        label: const Text('Capturar Evidencia'),
      ),
    );
  }
}