import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UbicacionPageGuiada(),
  ));
}

class UbicacionPageGuiada extends StatefulWidget {
  const UbicacionPageGuiada({super.key});

  @override
  State<UbicacionPageGuiada> createState() => _UbicacionPageGuiadaState();
}

class _UbicacionPageGuiadaState extends State<UbicacionPageGuiada> {
  Position? posicion;
  String mensaje = 'Sin ubicación';

  Future<void> obtener() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => mensaje = 'Activa el servicio de ubicación');
      return;
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
        setState(() => mensaje = 'Permiso de ubicación no disponible');
        return;
      }
    }
    final p = await Geolocator.getCurrentPosition();
    setState(() {
      posicion = p;
      mensaje = 'Ubicación obtenida';
    });
  }

  Future<void> abrirMapa() async {
    if (posicion == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${posicion!.latitude},${posicion!.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Ubicación - Guiado JuanPablo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.blue),
              const SizedBox(height: 12),
              Text(mensaje, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              if (posicion != null) ...[
                Text('Latitud: ${posicion!.latitude}'),
                Text('Longitud: ${posicion!.longitude}'),
                Text('Precisión: ${posicion!.accuracy} m'),
                const SizedBox(height: 16),
              ],
              FilledButton(onPressed: obtener, child: const Text('Obtener ubicación')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: abrirMapa, child: const Text('Abrir en mapa')),
            ],
          ),
        ),
      ),
    );
  }
}