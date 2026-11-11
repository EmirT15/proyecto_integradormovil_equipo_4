import 'package:flutter/foundation.dart';
import '../models/incidencia_model.dart';
import '../services/incidencia_db_service.dart';
import '../services/notificacion_service.dart';

class IncidenciaProvider extends ChangeNotifier {
  List<IncidenciaModel> _incidencias = [];
  bool _cargando = false;

  List<IncidenciaModel> get incidencias => _incidencias;
  bool get cargando => _cargando;

  Future<void> cargarIncidencias() async {
    _cargando = true;
    notifyListeners();
    _incidencias = await IncidenciaDBService.listar();
    _cargando = false;
    notifyListeners();
  }

  Future<void> agregarIncidencia(IncidenciaModel inc) async {
    await IncidenciaDBService.insertar(inc);
    await cargarIncidencias();
    await NotificacionService.mostrar(
      titulo: 'Reporte Registrado',
      cuerpo: 'Incidencia "${inc.titulo}" guardada correctamente.',
    );
  }
}