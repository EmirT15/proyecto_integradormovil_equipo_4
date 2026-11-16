class IncidenciaModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String fotoPath;
  final double latitud;
  final double longitud;
  final DateTime fechaHora;

  const IncidenciaModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.fotoPath,
    required this.latitud,
    required this.longitud,
    required this.fechaHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'fotoPath': fotoPath,
      'latitud': latitud,
      'longitud': longitud,
      'fechaHora': fechaHora.toIso8601String(),
    };
  }

  factory IncidenciaModel.fromMap(Map<String, dynamic> map) {
    return IncidenciaModel(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      fotoPath: map['fotoPath'],
      latitud: map['latitud'],
      longitud: map['longitud'],
      fechaHora: DateTime.parse(map['fechaHora']),
    );
  }
}