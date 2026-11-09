import '../models/tarea_model.dart';

class TareaService {
  // Simulación de carga de datos (se puede conectar a una BD local o API en el futuro)
  Future<List<TareaModel>> obtenerTareasIniciales() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TareaModel(
        id: '1',
        titulo: 'Refactorizar arquitectura Flutter',
        categoria: 'Móvil',
        fecha: DateTime.now(),
        prioridad: 'Alta',
      ),
      TareaModel(
        id: '2',
        titulo: 'Diseñar Dashboard Neumórfico',
        categoria: 'UI/UX',
        fecha: DateTime.now().add(const Duration(hours: 2)),
        prioridad: 'Media',
      ),
      TareaModel(
        id: '3',
        titulo: 'Pruebas de rendimiento y Provider',
        categoria: 'Móvil',
        fecha: DateTime.now().add(const Duration(hours: 4)),
        prioridad: 'Baja',
      ),
    ];
  }
}