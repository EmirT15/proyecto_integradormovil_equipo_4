import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  testWidgets('Carga la pantalla inicial correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Catálogo de Materias'), findsOneWidget);
  });
}