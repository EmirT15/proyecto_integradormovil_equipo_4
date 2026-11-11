class BitacoraModel {
  final String id;
  final String titulo;
  final String fotoPath;
  final DateTime fechaHora;
  final double accelX;
  final double accelY;
  final double accelZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;

  const BitacoraModel({
    required this.id,
    required this.titulo,
    required this.fotoPath,
    required this.fechaHora,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
  });
}