import 'package:flutter/material.dart';

import 'screens/ubicacion_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 8 - Guiada',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const UbicacionPage(),
    );
  }
}
