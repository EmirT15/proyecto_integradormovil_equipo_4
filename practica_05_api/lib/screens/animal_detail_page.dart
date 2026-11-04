import 'package:flutter/material.dart';

import '../models/animal.dart';

class AnimalDetailPage extends StatelessWidget {
  final Animal animal;

  const AnimalDetailPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del animal'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (animal.imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  animal.imagen!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.pets, size: 70)),
                    );
                  },
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(Icons.pets, size: 70),
              ),

            const SizedBox(height: 20),

            Text(
              animal.nombre,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              animal.nombreCientifico,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
            ),

            const Divider(height: 30),

            const Text(
              'Información de la observación',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha de observación'),
              subtitle: Text(animal.fechaObservacion ?? 'No disponible'),
            ),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Ubicación'),
              subtitle: Text(animal.ubicacion ?? 'No disponible'),
            ),

            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('ID de observación'),
              subtitle: Text(animal.id.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
