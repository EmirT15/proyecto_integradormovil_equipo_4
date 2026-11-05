import 'package:flutter/material.dart';

import '../models/publicacion.dart';

class PublicacionDetailPage extends StatelessWidget {
  final Publicacion publicacion;

  const PublicacionDetailPage({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de publicación'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identificador de la publicación.
            CircleAvatar(
              radius: 30,
              child: Text(
                '${publicacion.id}',
                style: const TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 24),

            // Información general.
            const Text(
              'Información de la publicación',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            Text(
              'Publicación #${publicacion.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Usuario relacionado: ${publicacion.userId}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 28),

            // Título completo.
            const Text(
              'Título',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              publicacion.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 28),

            // Contenido completo.
            const Text(
              'Contenido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              publicacion.cuerpo,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 32),

            // Botón para regresar.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Regresar a publicaciones'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
