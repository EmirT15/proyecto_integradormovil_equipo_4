import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tarea_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TareaProvider(),
      child: const TareasApp(),
    ),
  );
}

class TareasApp extends StatelessWidget {
  const TareasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard de Tareas - Práctica 7',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1BFFFF),
          surface: Color(0xFF1E1E2C),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}