import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/nota.dart';
import '../providers/nota_provider.dart';
import '../widgets/note_card.dart';

class NotasPage extends StatelessWidget {
  const NotasPage({super.key});

  Future<void> _mostrarFormulario(BuildContext context, {Nota? nota}) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => FormularioNotaDialog(nota: nota),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, Nota nota) async {
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

    if (confirmar != true || !context.mounted) return;

    final provider = context.read<NotaProvider>();
    final eliminado = await provider.eliminarNota(nota.id!);

    if (!context.mounted) return;

    if (!eliminado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'No se pudo eliminar la nota.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Mis notas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<NotaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.notas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.cargarNotas,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.notas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Todavía no tienes notas'),
                  Text('Presiona + para crear una'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.notas.length,
            itemBuilder: (context, index) {
              final nota = provider.notas[index];

              return NoteCard(
                title: nota.titulo,
                content: nota.contenido,
                onTap: () => _mostrarFormulario(context, nota: nota),
                onDelete: () => _confirmarEliminar(context, nota),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormularioNotaDialog extends StatefulWidget {
  final Nota? nota;

  const FormularioNotaDialog({super.key, this.nota});

  @override
  State<FormularioNotaDialog> createState() => _FormularioNotaDialogState();
}

class _FormularioNotaDialogState extends State<FormularioNotaDialog> {
  final _formularioKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _contenidoController;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(text: widget.nota?.titulo ?? '');

    _contenidoController = TextEditingController(
      text: widget.nota?.contenido ?? '',
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  Future<void> _guardarNota() async {
    if (!_formularioKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final nuevaNota = Nota(
      id: widget.nota?.id,
      titulo: _tituloController.text.trim(),
      contenido: _contenidoController.text.trim(),
    );

    final provider = context.read<NotaProvider>();

    final guardada = widget.nota == null
        ? await provider.agregarNota(nuevaNota)
        : await provider.actualizarNota(nuevaNota);

    if (!mounted) return;

    if (guardada) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'No se pudo guardar la nota.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.nota == null ? 'Nueva nota' : 'Editar nota'),
      content: Form(
        key: _formularioKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                enabled: !_guardando,
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
                controller: _contenidoController,
                enabled: !_guardando,
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
          onPressed: _guardando ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _guardando ? null : _guardarNota,
          icon: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_guardando ? 'Guardando...' : 'Guardar'),
        ),
      ],
    );
  }
}
