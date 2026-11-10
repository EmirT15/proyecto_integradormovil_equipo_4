import 'package:flutter/material.dart';
import 'screens/poi_dashboard_screen.dart';

void main() => runApp(const PoiApp());

class PoiApp extends StatelessWidget {
  const PoiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Puntos de Interés - Práctica 8',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          surface: Color(0xFF1E1E2C),
        ),
      ),
      home: const PoiDashboardScreen(),
    );
  }
}