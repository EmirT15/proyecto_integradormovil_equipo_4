import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/api_service.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final ApiService _apiService = ApiService();

  late Future<List<Usuario>> _usuariosFuture;

  @override
  void initState() {
    super.initState();

    // Consultar los usuarios al abrir la pantalla.
    _usuariosFuture = _apiService.obtenerUsuarios();
  }

  // Actualizar la lista de usuarios.
  Future<void> _actualizarUsuarios() async {
    final nuevaConsulta = _apiService.obtenerUsuarios();

    setState(() {
      _usuariosFuture = nuevaConsulta;
    });

    try {
      await nuevaConsulta;
    } catch (_) {
      // El error se mostrará mediante FutureBuilder.
    }
  }

  // Volver a consultar los usuarios si ocurre un error.
  void _reintentar() {
    setState(() {
      _usuariosFuture = _apiService.obtenerUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios de la API'),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Usuario>>(
        future: _usuariosFuture,

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
                      'No se pudieron cargar los usuarios.',
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

          // Obtener los usuarios recibidos.
          final List<Usuario> usuarios = snapshot.data ?? [];

          // Estado de lista vacía.
          if (usuarios.isEmpty) {
            return RefreshIndicator(
              onRefresh: _actualizarUsuarios,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No hay usuarios disponibles.')),
                ],
              ),
            );
          }

          // Estado de éxito.
          return RefreshIndicator(
            onRefresh: _actualizarUsuarios,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: usuarios.length,

              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${usuario.id}')),
                    title: Text(usuario.nombre),
                    subtitle: Text(usuario.correo),
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
