import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_8/main.dart';

void main() {
  testWidgets('La pantalla de Puntos de Interés se construye correctamente',
      (WidgetTester tester) async {
    // Construir la app completa dentro de MaterialApp
    await tester.pumpWidget(const MyApp());

    // El widget principal debe estar presente
    expect(find.byType(PuntosInteresPage), findsOneWidget);

    // El AppBar debe mostrar el título
    expect(find.text('Puntos de Interés'), findsOneWidget);

    // Debe existir el botón flotante para agregar ubicaciones
    expect(find.text('Agregar ubicación'), findsOneWidget);

    // Debe mostrarse el panel de ubicación actual
    expect(find.text('📍 Ubicación actual'), findsOneWidget);
  });

  testWidgets('El diálogo de agregar ubicación muestra los campos correctos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Presionar el botón flotante
    await tester.tap(find.text('Agregar ubicación'));
    await tester.pumpAndSettle();

    // El diálogo debe mostrar sus campos
    expect(find.text('Agregar punto de interés'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nombre (ej. Biblioteca)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Latitud'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Longitud'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });
}