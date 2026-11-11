import '../models/contador_model.dart';

class ContadorService {
  // Simula la obtención del valor inicial desde una fuente externa/persistente
  Future<ContadorModel> obtenerContadorInicial() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ContadorModel(
      valor: 0,
      ultimaModificacion: DateTime.now(),
    );
  }
}