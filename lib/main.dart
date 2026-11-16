import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'providers/nota_provider.dart';
import 'providers/tarea_provider.dart';
import 'providers/usuario_provider.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotaProvider()..cargarNotas()),
        ChangeNotifierProvider(create: (_) => TareaProvider()..cargarTareas()),
        ChangeNotifierProvider(
          create: (_) => UsuarioProvider()..cargarNombre(),
        ),
      ],
      child: const MiAplicacion(),
    ),
  );
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor Offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
