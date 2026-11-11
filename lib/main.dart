import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/incidencia_provider.dart';
import 'screens/incidencias_screen.dart';
import 'services/notificacion_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacionService.inicializar();

  runApp(
    ChangeNotifierProvider(
      create: (_) => IncidenciaProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IncidenciasScreen(),
      ),
    ),
  );
}