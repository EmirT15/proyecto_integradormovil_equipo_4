class Publicacion {
  final int id;
  final int userId;
  final String titulo;
  final String cuerpo;

  Publicacion({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.cuerpo,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'] as int,
      userId: json['userId'] as int,
      titulo: json['title'] as String,
      cuerpo: json['body'] as String,
    );
  }
}
