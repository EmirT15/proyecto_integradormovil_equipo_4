class Usuario {
  final int id;
  final String nombre;
  final String correo;

  Usuario({required this.id, required this.nombre, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nombre: json['name'] as String,
      correo: json['email'] as String,
    );
  }
}
