import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practica_06_persistencia/main.dart';
import 'package:practica_06_persistencia/providers/nota_provider.dart';
import 'package:practica_06_persistencia/providers/tarea_provider.dart';
import 'package:practica_06_persistencia/providers/usuario_provider.dart';
import 'package:practica_06_persistencia/screens/home_page.dart';

void main() {
  testWidgets('La aplicación muestra la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotaProvider()),
          ChangeNotifierProvider(create: (_) => TareaProvider()),
          ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ],
        child: const MiAplicacion(),
      ),
    );

    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Gestor Offline'), findsOneWidget);
    expect(find.text('Mis herramientas'), findsOneWidget);
    expect(find.text('Mis notas'), findsOneWidget);

    // Desplazarse hasta encontrar la tarjeta de tareas.
    await tester.scrollUntilVisible(find.text('Mis tareas'), 300);

    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
  });
}
