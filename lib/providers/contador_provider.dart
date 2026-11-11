import 'package:flutter/foundation.dart';
import '../services/contador_service.dart';

class ContadorProvider extends ChangeNotifier {
  final ContadorService _service = ContadorService();
  int _valor = 0;
  DateTime _ultimaModificacion = DateTime.now();

  int get valor => _valor;
  DateTime get ultimaModificacion => _ultimaModificacion;

  Future<void> inicializar() async {
    final contador = await _service.obtenerContadorInicial();
    _valor = contador.valor;
    _ultimaModificacion = contador.ultimaModificacion;
    notifyListeners();
  }

  void incrementar() {
    _valor++;
    _ultimaModificacion = DateTime.now();
    notifyListeners();
  }

  void reiniciar() {
    _valor = 0;
    _ultimaModificacion = DateTime.now();
    notifyListeners();
  }
}