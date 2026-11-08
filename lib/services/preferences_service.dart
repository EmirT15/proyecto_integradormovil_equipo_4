import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _nombreKey = 'nombre_usuario';
  static const String _filtroKey = 'filtro_tareas';

  // Guardar el nombre del usuario.
  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nombreKey, nombre);
  }

  // Recuperar el nombre del usuario.
  static Future<String> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_nombreKey) ?? 'Invitado';
  }

  // Guardar el filtro seleccionado.
  static Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_filtroKey, filtro);
  }

  // Recuperar el filtro seleccionado.
  static Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_filtroKey) ?? 'Todas';
  }
}
