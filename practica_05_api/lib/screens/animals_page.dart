import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../services/animal_service.dart';
import 'animal_detail_page.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  final AnimalService animalService = AnimalService();

  late Future<List<Animal>> futureAnimales;

  @override
  void initState() {
    super.initState();
    futureAnimales = animalService.obtenerAnimales();
  }

  Future<void> recargarAnimales() async {
    setState(() {
      futureAnimales = animalService.obtenerAnimales();
    });

    await futureAnimales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fauna de México'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Animal>>(
        future: futureAnimales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No se pudieron cargar los animales.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: recargarAnimales,
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final animales = snapshot.data ?? [];

          if (animales.isEmpty) {
            return const Center(child: Text('No se encontraron animales.'));
          }

          return RefreshIndicator(
            onRefresh: recargarAnimales,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: animales.length,
              itemBuilder: (context, index) {
                final animal = animales[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: animal.imagen != null
                          ? NetworkImage(animal.imagen!)
                          : null,
                      child: animal.imagen == null
                          ? const Icon(Icons.pets)
                          : null,
                    ),
                    title: Text(
                      animal.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      animal.nombreCientifico,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnimalDetailPage(animal: animal),
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
