import 'package:flutter/material.dart';
import 'screens/inventario_dashboard_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const InventarioApp());
}

class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Storage - Práctica 10',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121C),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          surface: Color(0xFF1E1E2C),
        ),
      ),
      home: const InventarioDashboardScreen(),
    );
  }
}