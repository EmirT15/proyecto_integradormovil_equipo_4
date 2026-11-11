import 'package:flutter/foundation.dart';
import '../models/producto_model.dart';
import '../services/producto_service.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _service = ProductoService();
  List<ProductoModel> _productos = [];
  bool _cargando = false;

  List<ProductoModel> get productos => _productos;
  bool get cargando => _cargando;

  Future<void> cargarProductos() async {
    _cargando = true;
    notifyListeners();

    _productos = await _service.obtenerProductos();

    _cargando = false;
    notifyListeners();
  }

  void agregarProducto(String nombre, double precio) {
    final nuevo = ProductoModel(
      id: DateTime.now().millisecondsSinceEpoch,
      nombre: nombre,
      precio: precio,
      fechaCreacion: DateTime.now(),
    );
    _productos.insert(0, nuevo);
    notifyListeners();
  }

  void eliminarProducto(int id) {
    _productos.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}