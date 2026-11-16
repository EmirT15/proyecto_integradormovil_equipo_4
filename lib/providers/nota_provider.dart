import 'package:flutter/foundation.dart';

import '../models/nota.dart';
import '../services/nota_service.dart';

class NotaProvider extends ChangeNotifier {
  List<Nota> _notas = [];
  bool _isLoading = false;
  String? _error;

  List<Nota> get notas => List.unmodifiable(_notas);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarNotas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notas = await NotaService.listar();
    } catch (e) {
      _error = 'No se pudieron cargar las notas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarNota(Nota nota) async {
    try {
      await NotaService.insertar(nota);
      await cargarNotas();
      return true;
    } catch (e) {
      _error = 'No se pudo agregar la nota: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarNota(Nota nota) async {
    try {
      await NotaService.actualizar(nota);
      await cargarNotas();
      return true;
    } catch (e) {
      _error = 'No se pudo actualizar la nota: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarNota(int id) async {
    try {
      await NotaService.eliminar(id);
      await cargarNotas();
      return true;
    } catch (e) {
      _error = 'No se pudo eliminar la nota: $e';
      notifyListeners();
      return false;
    }
  }
}
