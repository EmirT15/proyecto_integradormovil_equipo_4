import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  testWidgets('Prueba de carga inicial de la app', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}