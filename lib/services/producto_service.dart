import '../models/producto_model.dart';

class ProductoService {
  final List<ProductoModel> _productos = [
    ProductoModel(
      id: 1,
      nombre: 'Laptop Gamer',
      precio: 18500.50,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ProductoModel(
      id: 2,
      nombre: 'Teclado Mecánico',
      precio: 1250.00,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<ProductoModel>> obtenerProductos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_productos);
  }
}