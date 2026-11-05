class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final int pendienteSincronizar; // 1 = cambio local sin enviar al servidor

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    this.pendienteSincronizar = 1,
  });

  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    bool? completada,
    int? pendienteSincronizar,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
      pendienteSincronizar: pendienteSincronizar ?? this.pendienteSincronizar,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'completada': completada ? 1 : 0,
    'pendiente_sincronizar': pendienteSincronizar,
  };

  factory Tarea.fromMap(Map<String, dynamic> m) => Tarea(
    id: m['id'] as int?,
    titulo: m['titulo'] as String,
    descripcion: m['descripcion'] as String,
    completada: (m['completada'] as int) == 1,
    pendienteSincronizar: m['pendiente_sincronizar'] as int,
  );
}
