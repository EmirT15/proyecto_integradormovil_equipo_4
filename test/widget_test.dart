import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  testWidgets('Carga inicial de la app sin errores', (WidgetTester tester) async {
    // Construye la app y dispara un frame.
    await tester.pumpWidget(const MyApp());

    // Verifica que el widget principal cargó en pantalla
    expect(find.byType(MyApp), findsOneWidget);
  });
}