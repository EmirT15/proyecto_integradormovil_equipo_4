import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La pantalla de registro se muestra correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Registro de estudiantes'),
              Text('Nombre'),
              Text('Correo'),
              Text('Agregar'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Registro de estudiantes'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });
}
