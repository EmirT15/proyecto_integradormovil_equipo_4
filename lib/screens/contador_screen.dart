import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';
import '../widgets/contador_card.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 7 - Contador Provider'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ContadorProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContadorCard(
                    valor: provider.valor,
                    ultimaModificacion: provider.ultimaModificacion,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'btn_decrementar',
                        onPressed: () => provider.decrementar(),
                        tooltip: 'Decrementar',
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'btn_reiniciar',
                        onPressed: () => provider.reiniciar(),
                        tooltip: 'Reiniciar',
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.refresh),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'btn_incrementar',
                        onPressed: () => provider.incrementar(),
                        tooltip: 'Incrementar',
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}