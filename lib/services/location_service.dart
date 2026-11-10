import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  static Future<Position> obtenerPosicion() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Servicio de GPS desactivado. Por favor actívalo.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Permiso de ubicación denegado.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Permiso denegado permanentemente en la configuración.';
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  static double calcularDistancia({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    // Retorna la distancia en metros
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static Future<void> abrirNavegacion(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir la aplicación de mapas';
    }
  }
}