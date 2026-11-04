import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final UserService servicio = UserService();

  late Future<List<Usuario>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = servicio.obtenerUsuarios();
  }

  Future<void> actualizar() async {
    final nuevaSolicitud = servicio.obtenerUsuarios();

    setState(() {
      futuro = nuevaSolicitud;
    });

    await nuevaSolicitud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Usuario>>(
        future: futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futuro = servicio.obtenerUsuarios();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final usuarios = snapshot.data ?? [];

          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles'));
          }

          return RefreshIndicator(
            onRefresh: actualizar,
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                return ListTile(
                  leading: CircleAvatar(child: Text('${usuario.id}')),
                  title: Text(usuario.nombre),
                  subtitle: Text(usuario.correo),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
