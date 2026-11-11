import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'screens/practica_guiada_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ContadorProvider()..inicializar(),
      child: const MiAppGuiada(),
    ),
  );
}

class MiAppGuiada extends StatelessWidget {
  const MiAppGuiada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Guiada 07 - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PracticaGuiadaScreen(),
    );
  }
}