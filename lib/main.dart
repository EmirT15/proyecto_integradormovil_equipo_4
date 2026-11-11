import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAppEvaluable10());
}

class MiAppEvaluable10 extends StatelessWidget {
  const MiAppEvaluable10({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Inventario - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      home: const PantallaInicio(),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Móvil - JuanPablo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_download),
              label: const Text('Ver Productos (API REST)'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaApi())),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Registrar Almacén (GPS)'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaGps())),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaApi extends StatefulWidget {
  const PantallaApi({super.key});

  @override
  State<PantallaApi> createState() => _PantallaApiState();
}

class _PantallaApiState extends State<PantallaApi> {
  List<dynamic> _items = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _fetchApi();
  }

  Future<void> _fetchApi() async {
    try {
      final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'));
      if (res.statusCode == 200) {
        setState(() {
          _items = json.decode(res.body);
          _cargando = false;
        });
      }
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo API REST')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(_items[i]['title']),
                subtitle: Text(_items[i]['body']),
              ),
            ),
    );
  }
}

class PantallaGps extends StatefulWidget {
  const PantallaGps({super.key});

  @override
  State<PantallaGps> createState() => _PantallaGpsState();
}

class _PantallaGpsState extends State<PantallaGps> {
  String _coords = 'Presiona el botón para capturar ubicación';

  Future<void> _obtenerGps() async {
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _coords = 'Lat: ${pos.latitude}, Lng: ${pos.longitude}';
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ubicación registrada: $_coords')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación de Almacén')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_coords, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _obtenerGps, child: const Text('Capturar y Notificar')),
          ],
        ),
      ),
    );
  }
}