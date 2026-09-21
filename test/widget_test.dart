import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  testWidgets('La pantalla de registro se muestra correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Registro de estudiantes'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });
}
