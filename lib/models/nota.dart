class Nota {
  final int? id;
  final String titulo;
  final String contenido;

  Nota({this.id, required this.titulo, required this.contenido});

  // Convertir un registro de SQLite a un objeto Nota.
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      contenido: map['contenido'] as String,
    );
  }

  // Convertir un objeto Nota a un mapa para SQLite.
  Map<String, dynamic> toMap() {
    return {'id': id, 'titulo': titulo, 'contenido': contenido};
  }
}
