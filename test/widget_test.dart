import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_integradormovil_equipo_4/main.dart';

void main() {
  // Inicializar la fábrica de SQLite FFI para el entorno de pruebas de Dart
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Carga inicial de NotasPage', (WidgetTester tester) async {
    // Inicializar SharedPreferences en memoria con valores vacíos para el test
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(home: NotasPage()));
    await tester.pumpAndSettle();

    expect(find.byType(NotasPage), findsOneWidget);
  });
}