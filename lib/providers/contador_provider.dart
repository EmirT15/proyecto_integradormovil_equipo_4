import 'package:flutter/foundation.dart';
import '../models/contador_model.dart';

class ContadorProvider extends ChangeNotifier {
  ContadorModel _state = ContadorModel(
    valor: 0,
    ultimaModificacion: DateTime.now(),
  );

  int get valor => _state.valor;
  DateTime get ultimaModificacion => _state.ultimaModificacion;

  void incrementar() {
    _state = _state.copyWith(
      valor: _state.valor + 1,
      ultimaModificacion: DateTime.now(),
    );
    notifyListeners();
  }

  void decrementar() {
    if (_state.valor > 0) {
      _state = _state.copyWith(
        valor: _state.valor - 1,
        ultimaModificacion: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void reiniciar() {
    _state = ContadorModel(
      valor: 0,
      ultimaModificacion: DateTime.now(),
    );
    notifyListeners();
  }
}