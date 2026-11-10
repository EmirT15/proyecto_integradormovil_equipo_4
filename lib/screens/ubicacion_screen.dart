import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/geolocator_service.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  Position? posicion;
  String mensaje = 'Sin ubicación';
  bool cargando = false;

  Future<void> obtener() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });
    try {
      final p = await GeolocatorService.obtenerPosicionActual();
      setState(() {
        posicion = p;
        mensaje = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() {
        mensaje = e.toString();
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> abrirMapa() async {
    if (posicion == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${posicion!.latitude},${posicion!.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el mapa externo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ubicación - Guiado'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (cargando) const CircularProgressIndicator(),
              if (posicion != null && !cargando) ...[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Latitud: ${posicion!.latitude}'),
                        Text('Longitud: ${posicion!.longitude}'),
                        Text(
                          'Precisión: ${posicion!.accuracy.toStringAsFixed(2)} m',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton.icon(
                onPressed: cargando ? null : obtener,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener ubicación'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: posicion == null ? null : abrirMapa,
                icon: const Icon(Icons.map),
                label: const Text('Abrir en mapa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
