import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_6/models/tarea.dart';

void main() {
  test('Tarea.toMap / fromMap ida y vuelta', () {
    final t = Tarea(titulo: 'A', descripcion: 'B');
    final map = t.toMap();
    expect(map['titulo'], 'A');
    expect(map['completada'], 0);

    final r = Tarea.fromMap({
      'id': 1,
      'titulo': 'X',
      'descripcion': 'Y',
      'completada': 1,
      'pendiente_sincronizar': 0,
    });
    expect(r.id, 1);
    expect(r.completada, true);
    expect(r.pendienteSincronizar, 0);
  });
}
