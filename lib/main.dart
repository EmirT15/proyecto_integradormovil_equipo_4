import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatFactsPage(),
    ));

class CatFact {
  final String fact;
  final int length;

  CatFact({required this.fact, required this.length});

  factory CatFact.fromJson(Map<String, dynamic> json) => CatFact(
        fact: json['fact'],
        length: json['length'],
      );
}

class CatFactsPage extends StatefulWidget {
  const CatFactsPage({super.key});

  @override
  State<CatFactsPage> createState() => _CatFactsPageState();
}

class _CatFactsPageState extends State<CatFactsPage> {
  late Future<List<CatFact>> futuroDatos;

  @override
  void initState() {
    super.initState();
    futuroDatos = cargarDatos();
  }

  Future<List<CatFact>> cargarDatos() async {
    final response = await http.get(Uri.parse('https://catfact.ninja/facts?limit=20'));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List datos = body['data'];
    return datos.map((e) => CatFact.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Curiosos de Gatos 🐱')),
      body: FutureBuilder<List<CatFact>>(
        future: futuroDatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final lista = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async => setState(() => futuroDatos = cargarDatos()),
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final item = lista[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(item.fact),
                    subtitle: Text('Longitud del texto: ${item.length} caracteres'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleFactPage(fact: item, index: i + 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetalleFactPage extends StatelessWidget {
  final CatFact fact;
  final int index;

  const DetalleFactPage({super.key, required this.fact, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dato Curioso #$index')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pets, size: 50, color: Colors.orange),
                const SizedBox(height: 15),
                Text(
                  fact.fact,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}