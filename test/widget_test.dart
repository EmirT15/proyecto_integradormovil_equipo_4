import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  testWidgets('Carga inicial del Gestor de Tareas', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TareasPage()));
    expect(find.byType(TareasPage), findsOneWidget);
  });
}