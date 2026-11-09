class ContadorModel {
  final int valor;
  final DateTime ultimaModificacion;

  const ContadorModel({
    required this.valor,
    required this.ultimaModificacion,
  });

  ContadorModel copyWith({
    int? valor,
    DateTime? ultimaModificacion,
  }) {
    return ContadorModel(
      valor: valor ?? this.valor,
      ultimaModificacion: ultimaModificacion ?? this.ultimaModificacion,
    );
  }
}