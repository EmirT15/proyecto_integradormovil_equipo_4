import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const PropinaPage(),
  );
}

class PropinaPage extends StatefulWidget {
  const PropinaPage({super.key});
  @override
  State<PropinaPage> createState() => _PropinaPageState();
}

class _PropinaPageState extends State<PropinaPage> {
  final consumo = TextEditingController();
  double porcentaje = 10;
  double propina = 0;
  double total = 0;
  void calcular() {
    final valor = double.tryParse(consumo.text) ?? 0;
    setState(() {
      propina = valor * porcentaje / 100;
      total = valor + propina;
    });
  }

  @override
  void dispose() {
    consumo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de propina')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: consumo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Consumo',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Propina: ${porcentaje.toInt()} %'),
            Slider(
              value: porcentaje,
              min: 0,
              max: 30,
              divisions: 6,
              onChanged: (v) => setState(() => porcentaje = v),
            ),
            FilledButton(onPressed: calcular, child: const Text('Calcular')),
            const SizedBox(height: 20),
            Text('Propina: \$${propina.toStringAsFixed(2)}'),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
