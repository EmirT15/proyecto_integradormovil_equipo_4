class IncidenciaModel {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? rutaFoto;
  final double latitud;
  final double longitud;
  final String fechaHora;

  IncidenciaModel({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.rutaFoto,
    required this.latitud,
    required this.longitud,
    required this.fechaHora,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'rutaFoto': rutaFoto,
        'latitud': latitud,
        'longitud': longitud,
        'fechaHora': fechaHora,
      };

  factory IncidenciaModel.fromMap(Map<String, dynamic> map) => IncidenciaModel(
        id: map['id'],
        titulo: map['titulo'],
        descripcion: map['descripcion'],
        categoria: map['categoria'],
        rutaFoto: map['rutaFoto'],
        latitud: map['latitud'],
        longitud: map['longitud'],
        fechaHora: map['fechaHora'],
      );
}