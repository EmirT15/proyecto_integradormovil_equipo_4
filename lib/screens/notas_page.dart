import 'package:flutter/material.dart';

import '../models/nota.dart';
import '../services/nota_service.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  List<Nota> notas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarNotas();
  }

  // Consultar las notas almacenadas en SQLite.
  Future<void> cargarNotas() async {
    final resultado = await NotaService.listar();

    if (!mounted) return;

    setState(() {
      notas = resultado;
      cargando = false;
    });
  }

  // Crear o editar una nota.
  Future<void> mostrarFormulario({Nota? nota}) async {
    final tituloController = TextEditingController(text: nota?.titulo ?? '');

    final contenidoController = TextEditingController(
      text: nota?.contenido ?? '',
    );

    final formularioKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(nota == null ? 'Nueva nota' : 'Editar nota'),
          content: Form(
            key: formularioKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: contenidoController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe el contenido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              onPressed: () async {
                if (!formularioKey.currentState!.validate()) {
                  return;
                }

                final nuevaNota = Nota(
                  id: nota?.id,
                  titulo: tituloController.text.trim(),
                  contenido: contenidoController.text.trim(),
                );

                if (nota == null) {
                  await NotaService.insertar(nuevaNota);
                } else {
                  await NotaService.actualizar(nuevaNota);
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        );
      },
    );

    tituloController.dispose();
    contenidoController.dispose();

    if (mounted) {
      await cargarNotas();
    }
  }

  // Eliminar una nota con confirmación.
  Future<void> confirmarEliminar(Nota nota) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Deseas eliminar "${nota.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await NotaService.eliminar(nota.id!);
      await cargarNotas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : notas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Todavía no tienes notas'),
                  Text('Presiona + para crear una'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.description)),
                    title: Text(
                      nota.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      nota.contenido,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => mostrarFormulario(nota: nota),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar nota',
                      onPressed: () => confirmarEliminar(nota),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () => mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
