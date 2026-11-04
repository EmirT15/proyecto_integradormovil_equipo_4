class Animal {
  final int id;
  final String nombre;
  final String nombreCientifico;
  final String? imagen;
  final String? fechaObservacion;
  final String? ubicacion;

  Animal({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    this.imagen,
    this.fechaObservacion,
    this.ubicacion,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    final taxon = json['taxon'] ?? {};
    final foto = taxon['default_photo'];

    return Animal(
      id: json['id'] ?? 0,
      nombre:
          taxon['preferred_common_name'] ??
          json['species_guess'] ??
          'Animal sin identificar',
      nombreCientifico: taxon['name'] ?? 'No disponible',
      imagen: foto?['medium_url'],
      fechaObservacion: json['observed_on'],
      ubicacion: json['place_guess'],
    );
  }
}
