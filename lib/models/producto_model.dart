class ProductoModel {
  final String id;
  final String nombre;
  final String sku;
  final int cantidad;
  final double precio;
  final String fotoPath;

  const ProductoModel({
    required this.id,
    required this.nombre,
    required this.sku,
    required this.cantidad,
    required this.precio,
    required this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'sku': sku,
      'cantidad': cantidad,
      'precio': precio,
      'fotoPath': fotoPath,
    };
  }

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: map['id'],
      nombre: map['nombre'],
      sku: map['sku'],
      cantidad: map['cantidad'],
      precio: map['precio'],
      fotoPath: map['fotoPath'],
    );
  }
}