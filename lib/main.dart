import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/producto_provider.dart';
import 'screens/practica_evaluativa_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductoProvider(),
      child: const MiAppEvaluativa(),
    ),
  );
}

class MiAppEvaluativa extends StatelessWidget {
  const MiAppEvaluativa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 07 Evaluativa - JuanPablo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PracticaEvaluativaScreen(),
    );
  }
}