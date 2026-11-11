import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/punto_interes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF3F51B5);
    return MaterialApp(
      title: 'Puntos de Interés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: seed, width: 2),
          ),
        ),
      ),
      home: const PuntosInteresPage(),
    );
  }
}

class PuntosInteresPage extends StatefulWidget {
  const PuntosInteresPage({super.key});

  @override
  State<PuntosInteresPage> createState() => _PuntosInteresPageState();
}

class _PuntosInteresPageState extends State<PuntosInteresPage> {
  Position? _posicionActual;
  String _mensaje = 'Obteniendo tu ubicación actual...';
  bool _cargando = true;
  final List<PuntoInteres> _puntos = [];

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
  }

  Future<void> _obtenerUbicacionActual() async {
    setState(() => _cargando = true);
    try {
      bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicioHabilitado) {
        if (!mounted) return;
        setState(() {
          _mensaje = 'Activa el GPS del dispositivo.';
          _cargando = false;
        });
        return;
      }

      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _mensaje = 'Permiso de ubicación denegado.';
            _cargando = false;
          });
          return;
        }
      }
      if (permiso == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _mensaje = 'Permiso denegado permanentemente.';
          _cargando = false;
        });
        return;
      }

      Position posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (!mounted) return;
      setState(() {
        _posicionActual = posicion;
        _mensaje = 'Ubicación actual';
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensaje = 'Error al obtener ubicación.';
        _cargando = false;
      });
    }
  }

  Future<void> _agregarPunto() async {
    final nombreCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lngCtrl = TextEditingController();

    if (_posicionActual != null) {
      latCtrl.text = _posicionActual!.latitude.toStringAsFixed(6);
      lngCtrl.text = _posicionActual!.longitude.toStringAsFixed(6);
    }

    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.add_location_alt, color: Color(0xFF3F51B5)),
            SizedBox(width: 8),
            Expanded(child: Text('Nuevo punto de interés')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej. Biblioteca Central',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: latCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  prefixIcon: Icon(Icons.public),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  prefixIcon: Icon(Icons.explore_outlined),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.check),
            label: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (resultado != true) return;

    final nombre = nombreCtrl.text.trim();
    final lat = double.tryParse(latCtrl.text.trim());
    final lng = double.tryParse(lngCtrl.text.trim());

    if (nombre.isEmpty || lat == null || lng == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Datos inválidos. Revisa los campos.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _puntos.add(PuntoInteres(nombre: nombre, latitud: lat, longitud: lng));
    });
  }

  double? _distanciaMetros(PuntoInteres p) {
    if (_posicionActual == null) return null;
    return Geolocator.distanceBetween(
      _posicionActual!.latitude,
      _posicionActual!.longitude,
      p.latitud,
      p.longitud,
    );
  }

  Future<void> _abrirMapa(PuntoInteres p) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${p.latitud},${p.longitud}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el mapa.')),
      );
    }
  }

  void _eliminarPunto(int index) {
    final eliminado = _puntos[index];
    setState(() => _puntos.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${eliminado.nombre}" eliminado'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() => _puntos.insert(index, eliminado)),
        ),
      ),
    );
  }

  String _formatearDistancia(double? metros) {
    if (metros == null) return 'Sin ubicación';
    if (metros < 1000) return '${metros.toStringAsFixed(0)} m';
    return '${(metros / 1000).toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---------- AppBar con gradiente ----------
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF3F51B5),
            actions: [
              IconButton(
                tooltip: 'Actualizar ubicación',
                icon: const Icon(Icons.my_location),
                onPressed: _obtenerUbicacionActual,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 14),
              title: const Text('Puntos de Interés'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3F51B5), Color(0xFF7E57C2)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: Icon(Icons.public,
                          size: 200, color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -30,
                      child: Icon(Icons.location_on,
                          size: 160, color: Colors.white.withValues(alpha: 0.08)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------- Tarjeta de ubicación actual ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _TarjetaUbicacionActual(
                cargando: _cargando,
                mensaje: _mensaje,
                posicion: _posicionActual,
              ),
            ),
          ),

          // ---------- Encabezado de lista ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Text(
                    'Mis lugares',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_puntos.length}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- Lista o estado vacío ----------
          if (_puntos.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EstadoVacio(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList.separated(
                itemCount: _puntos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final p = _puntos[i];
                  final dist = _distanciaMetros(p);
                  return _TarjetaPunto(
                    punto: p,
                    indice: i,
                    distancia: _formatearDistancia(dist),
                    onMapa: () => _abrirMapa(p),
                    onEliminar: () => _eliminarPunto(i),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarPunto,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar ubicación'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

// ================== TARJETA UBICACIÓN ACTUAL ==================
class _TarjetaUbicacionActual extends StatelessWidget {
  final bool cargando;
  final String mensaje;
  final Position? posicion;

  const _TarjetaUbicacionActual({
    required this.cargando,
    required this.mensaje,
    required this.posicion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: cargando
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.my_location, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                if (posicion != null)
                  Text(
                    'Lat: ${posicion!.latitude.toStringAsFixed(6)}\n'
                    'Lng: ${posicion!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  )
                else if (!cargando)
                  Text(
                    'Sin coordenadas disponibles',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================== TARJETA DE PUNTO ==================
class _TarjetaPunto extends StatelessWidget {
  final PuntoInteres punto;
  final int indice;
  final String distancia;
  final VoidCallback onMapa;
  final VoidCallback onEliminar;

  const _TarjetaPunto({
    required this.punto,
    required this.indice,
    required this.distancia,
    required this.onMapa,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar numerado con color
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7E57C2), Color(0xFF3F51B5)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                '${indice + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    punto.nombre,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${punto.latitud.toStringAsFixed(5)}, '
                          '${punto.longitud.toStringAsFixed(5)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.straighten,
                            size: 12, color: Color(0xFF3F51B5)),
                        const SizedBox(width: 4),
                        Text(
                          distancia,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3F51B5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Acciones
            Column(
              children: [
                _BotonAccion(
                  icono: Icons.map_outlined,
                  color: const Color(0xFF2E7D32),
                  tooltip: 'Abrir en mapa',
                  onTap: onMapa,
                ),
                _BotonAccion(
                  icono: Icons.delete_outline,
                  color: Colors.red.shade400,
                  tooltip: 'Eliminar',
                  onTap: onEliminar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonAccion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.icono,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icono, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

// ================== ESTADO VACÍO ==================
class _EstadoVacio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF3F51B5).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_searching,
                  size: 56, color: Color(0xFF3F51B5)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aún no hay lugares guardados',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega al menos 3 puntos de interés con el botón de abajo para cumplir el ejercicio.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}