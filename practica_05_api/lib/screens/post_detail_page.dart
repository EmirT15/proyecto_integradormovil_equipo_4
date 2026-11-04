import 'package:flutter/material.dart';

import '../models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de publicación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 35,
                child: Text('${post.id}', style: const TextStyle(fontSize: 24)),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'IDENTIFICADOR',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 5),

            Text('${post.id}', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            const Text(
              'TÍTULO',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            const Text(
              'CONTENIDO DE LA PUBLICACIÓN',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Text(post.body, style: const TextStyle(fontSize: 17, height: 1.6)),

            const SizedBox(height: 25),

            Text(
              'Usuario: ${post.userId}',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
