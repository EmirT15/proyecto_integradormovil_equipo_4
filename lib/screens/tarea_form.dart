import 'package:flutter/material.dart';

import '../models/tarea.dart';

class TareaForm extends StatefulWidget {
  final Tarea? tarea;
  const TareaForm({super.key, this.tarea});

  @override
  State<TareaForm> createState() => _TareaFormState();
}

class _TareaFormState extends State<TareaForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tarea?.titulo ?? '');
    _descCtrl = TextEditingController(text: widget.tarea?.descripcion ?? '');
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Tarea(
        id: widget.tarea?.id,
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descCtrl.text.trim(),
        completada: widget.tarea?.completada ?? false,
        pendienteSincronizar: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.tarea != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar tarea' : 'Nueva tarea'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ej. Comprar despensa',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa un título'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descCtrl,
                minLines: 4,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Detalles de la tarea…',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa una descripción'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardar,
                icon: Icon(esEdicion ? Icons.save : Icons.check),
                label: Text(esEdicion ? 'Actualizar tarea' : 'Guardar tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}