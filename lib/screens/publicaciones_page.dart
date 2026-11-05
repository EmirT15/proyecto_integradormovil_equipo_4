import 'package:flutter/material.dart';

import '../models/publicacion.dart';
import '../services/api_service.dart';
import 'publicacion_detail_page.dart';

class PublicacionesPage extends StatefulWidget {
  const PublicacionesPage({super.key});

  @override
  State<PublicacionesPage> createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  final ApiService _apiService = ApiService();

  late Future<List<Publicacion>> _publicacionesFuture;

  @override
  void initState() {
    super.initState();

    // Consultar publicaciones al abrir la pantalla.
    _publicacionesFuture = _apiService.obtenerPublicaciones();
  }

  // Actualizar las publicaciones.
  Future<void> _actualizarPublicaciones() async {
    final nuevaConsulta = _apiService.obtenerPublicaciones();

    setState(() {
      _publicacionesFuture = nuevaConsulta;
    });

    try {
      await nuevaConsulta;
    } catch (_) {
      // FutureBuilder mostrará el error.
    }
  }

  // Volver a consultar cuando ocurre un error.
  void _reintentar() {
    setState(() {
      _publicacionesFuture = _apiService.obtenerPublicaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones'), centerTitle: true),

      body: FutureBuilder<List<Publicacion>>(
        future: _publicacionesFuture,

        builder: (context, snapshot) {
          // Estado de carga.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de error.
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
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudieron cargar las publicaciones.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reintentar,
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Obtener los datos recibidos.
          final List<Publicacion> publicaciones = snapshot.data ?? [];

          // Estado de lista vacía.
          if (publicaciones.isEmpty) {
            return RefreshIndicator(
              onRefresh: _actualizarPublicaciones,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No hay publicaciones disponibles.')),
                ],
              ),
            );
          }

          // Estado de éxito.
          return RefreshIndicator(
            onRefresh: _actualizarPublicaciones,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: publicaciones.length,

              itemBuilder: (context, index) {
                final publicacion = publicaciones[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${publicacion.id}')),

                    title: Text(
                      publicacion.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        publicacion.cuerpo,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PublicacionDetailPage(publicacion: publicacion),
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
