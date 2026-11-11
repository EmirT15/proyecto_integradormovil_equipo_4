import 'package:flutter/material.dart';
import '../widgets/tarjeta_contador_widget.dart';
import '../widgets/botones_contador_widget.dart';

class PracticaGuiadaScreen extends StatelessWidget {
  const PracticaGuiadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica Guiada 07 - JuanPablo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TarjetaContadorWidget(),
              SizedBox(height: 24),
              BotonesContadorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}