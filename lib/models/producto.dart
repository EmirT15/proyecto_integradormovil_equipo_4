class Producto {
  final int id;
  final String titulo;
  final String descripcion;
  final double precio;
  final String categoria;
  final double calificacion;
  final String imagen;

  Producto({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.calificacion,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      titulo: json['title'],
      descripcion: json['description'],
      precio: (json['price'] as num).toDouble(),
      categoria: json['category'],
      calificacion: (json['rating'] as num).toDouble(),
      imagen: json['thumbnail'],
    );
  }
}