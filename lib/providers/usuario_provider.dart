import 'package:flutter/foundation.dart';

import '../services/preferences_service.dart';

class UsuarioProvider extends ChangeNotifier {
  String _nombre = 'Invitado';
  bool _isLoading = false;
  String? _error;

  String get nombre => _nombre;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarNombre() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nombre = await PreferencesService.leerNombre();
    } catch (e) {
      _error = 'No se pudo cargar el nombre: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarNombre(String nuevoNombre) async {
    final nombreValidado = nuevoNombre.trim();

    if (nombreValidado.isEmpty) {
      _error = 'El nombre no puede estar vacío.';
      notifyListeners();
      return false;
    }

    try {
      await PreferencesService.guardarNombre(nombreValidado);

      _nombre = nombreValidado;
      _error = null;
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'No se pudo guardar el nombre: $e';
      notifyListeners();
      return false;
    }
  }
}
