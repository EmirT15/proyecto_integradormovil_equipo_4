import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAppPuntosInteres());
}

class MiAppPuntosInteres extends StatelessWidget {
  const MiAppPuntosInteres({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puntos de Interés - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const PuntosInteresScreen(),
    );
  }
}

class PuntoInteres {
  final String nombre;
  final double latitud;
  final double longitud;

  PuntoInteres({required this.nombre, required this.latitud, required this.longitud});
}

class PuntosInteresScreen extends StatefulWidget {
  const PuntosInteresScreen({super.key});

  @override
  State<PuntosInteresScreen> createState() => _PuntosInteresScreenState();
}

class _PuntosInteresScreenState extends State<PuntosInteresScreen> {
  Position? _posicionActual;
  String _estadoGPS = 'Obteniendo GPS...';

  // Tres puntos de interés por defecto
  final List<PuntoInteres> _puntos = [
    PuntoInteres(nombre: 'Parque Central', latitud: 19.8455, longitud: -90.5372),
    PuntoInteres(nombre: 'Centro Tecnológico', latitud: 19.8480, longitud: -90.5310),
    PuntoInteres(nombre: 'Biblioteca Principal', latitud: 19.8510, longitud: -90.5280),
  ];

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
  }

  Future<void> _obtenerUbicacionActual() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => _estadoGPS = 'Servicio de ubicación desactivado');
      return;
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
        setState(() => _estadoGPS = 'Permiso denegado');
        return;
      }
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _posicionActual = pos;
      _estadoGPS = 'Ubicación GPS actualizada';
    });
  }

  void _agregarPuntoModal() {
    final nombreCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lngCtrl = TextEditingController();

    if (_posicionActual != null) {
      latCtrl.text = _posicionActual!.latitude.toString();
      lngCtrl.text = _posicionActual!.longitude.toString();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Guardar Nuevo Punto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre del punto')),
            TextField(controller: latCtrl, decoration: const InputDecoration(labelText: 'Latitud'), keyboardType: TextInputType.number),
            TextField(controller: lngCtrl, decoration: const InputDecoration(labelText: 'Longitud'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final lat = double.tryParse(latCtrl.text);
              final lng = double.tryParse(lngCtrl.text);
              if (nombreCtrl.text.isNotEmpty && lat != null && lng != null) {
                setState(() {
                  _puntos.add(PuntoInteres(nombre: nombreCtrl.text, latitud: lat, longitud: lng));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirMapa(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  double _calcularDistancia(double lat, double lng) {
    if (_posicionActual == null) return 0.0;
    return Geolocator.distanceBetween(
      _posicionActual!.latitude,
      _posicionActual!.longitude,
      lat,
      lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de Interés - JuanPablo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _obtenerUbicacionActual,
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            color: Colors.deepOrange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.deepOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_estadoGPS, style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (_posicionActual != null)
                          Text('Lat: ${_posicionActual!.latitude.toStringAsFixed(4)}, Lng: ${_posicionActual!.longitude.toStringAsFixed(4)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Lugares Guardados:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _puntos.length,
              itemBuilder: (context, index) {
                final p = _puntos[index];
                final distMetros = _calcularDistancia(p.latitud, p.longitud);
                final distKm = (distMetros / 1000).toStringAsFixed(2);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.place)),
                    title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Lat: ${p.latitud}, Lng: ${p.longitud}\nDistancia: ${distMetros.toStringAsFixed(0)} m ($distKm km)'),
                    trailing: IconButton(
                      icon: const Icon(Icons.map, color: Colors.blue),
                      onPressed: () => _abrirMapa(p.latitud, p.longitud),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarPuntoModal,
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}