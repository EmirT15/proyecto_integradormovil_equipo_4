import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/punto_interes_model.dart';
import '../services/location_service.dart';
import '../widgets/current_location_header.dart';
import '../widgets/poi_card.dart';

class PoiDashboardScreen extends StatefulWidget {
  const PoiDashboardScreen({super.key});

  @override
  State<PoiDashboardScreen> createState() => _PoiDashboardScreenState();
}

class _PoiDashboardScreenState extends State<PoiDashboardScreen> {
  Position? _posicionActual;
  bool _cargando = false;

  // Al menos 3 puntos de interés guardados requeridos por el manual
  final List<PuntoInteresModel> _puntos = [
    const PuntoInteresModel(
      id: '1',
      nombre: 'Laboratorio de Cómputo (ITESCAM)',
      descripcion: 'Área de desarrollo móvil',
      latitud: 19.9868,
      longitud: -90.0526,
    ),
    const PuntoInteresModel(
      id: '2',
      nombre: 'Plaza Central de Dzibalchén',
      descripcion: 'Punto de reunión cívico',
      latitud: 19.5312,
      longitud: -89.7562,
    ),
    const PuntoInteresModel(
      id: '3',
      nombre: 'Centro Histórico de Campeche',
      descripcion: 'Zona patrimonial y turística',
      latitud: 19.8454,
      longitud: -90.5369,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _actualizarUbicacion();
  }

  Future<void> _actualizarUbicacion() async {
    setState(() => _cargando = true);
    try {
      final pos = await LocationService.obtenerPosicion();
      setState(() => _posicionActual = pos);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _agregarNuevoPunto() {
    final nombreController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guardar Ubicación Actual como POI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nombreController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nombre del lugar (ej. Mi Casa)',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF12121C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Descripción breve',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF12121C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  if (_posicionActual == null) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Obtén la ubicación GPS antes de guardar.'),
                      ),
                    );
                    return;
                  }
                  if (nombreController.text.trim().isNotEmpty) {
                    setState(() {
                      _puntos.add(
                        PuntoInteresModel(
                          id: DateTime.now().toString(),
                          nombre: nombreController.text.trim(),
                          descripcion: descController.text.trim(),
                          latitud: _posicionActual!.latitude,
                          longitud: _posicionActual!.longitude,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Guardar POI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de Interés (POI) & GPS'),
        backgroundColor: const Color(0xFF12121C),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrentLocationHeader(
                posicion: _posicionActual,
                cargando: _cargando,
                onRefresh: _actualizarUbicacion,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Puntos Guardados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _agregarNuevoPunto,
                    icon: const Icon(Icons.add_location_alt, color: Color(0xFF00E5FF)),
                    label: const Text(
                      'Nuevo POI',
                      style: TextStyle(color: Color(0xFF00E5FF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _puntos.length,
                  itemBuilder: (context, index) {
                    final poi = _puntos[index];
                    double? dist;
                    if (_posicionActual != null) {
                      dist = LocationService.calcularDistancia(
                        startLat: _posicionActual!.latitude,
                        startLng: _posicionActual!.longitude,
                        endLat: poi.latitud,
                        endLng: poi.longitud,
                      );
                    }
                    return PoiCard(poi: poi, distanciaMetros: dist);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}