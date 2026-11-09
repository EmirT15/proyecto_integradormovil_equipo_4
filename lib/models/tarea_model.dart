class TareaModel {
  final String id;
  final String titulo;
  final String categoria;
  final DateTime fecha;
  final bool completada;
  final String prioridad; // 'Alta', 'Media', 'Baja'

  const TareaModel({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.fecha,
    this.completada = false,
    this.prioridad = 'Media',
  });

  TareaModel copyWith({
    String? id,
    String? titulo,
    String? categoria,
    DateTime? fecha,
    bool? completada,
    String? prioridad,
  }) {
    return TareaModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      fecha: fecha ?? this.fecha,
      completada: completada ?? this.completada,
      prioridad: prioridad ?? this.prioridad,
    );
  }
}