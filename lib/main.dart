import 'package:flutter/material.dart';
import 'screens/bitacora_dashboard_screen.dart';

void main() => runApp(const BitacoraApp());

class BitacoraApp extends StatelessWidget {
  const BitacoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitácora de Inspección - Práctica 9',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC),
          surface: Color(0xFF1E1E2C),
        ),
      ),
      home: const BitacoraDashboardScreen(),
    );
  }
}