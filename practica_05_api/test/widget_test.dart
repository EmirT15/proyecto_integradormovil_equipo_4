import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/screens/users_page.dart';

void main() {
  testWidgets('La aplicación muestra la pantalla de usuarios', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: UsuariosPage()));

    expect(find.text('Usuarios REST'), findsOneWidget);
  });
}
