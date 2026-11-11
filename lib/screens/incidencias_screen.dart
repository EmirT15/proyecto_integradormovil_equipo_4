import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/incidencia_model.dart';
import '../providers/incidencia_provider.dart';

class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<IncidenciaProvider>();
    Future.microtask(() => provider.cargarIncidencias());
  }

  void _abrirFormulario() {
    final formKey = GlobalKey<FormState>();
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String categoria = 'Vía Pública';
    XFile? foto;
    Position? pos;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 16, right: 16,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nuevo Reporte de Incidencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (v) => v!.trim().isEmpty ? 'Ingrese título' : null,
                  ),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (v) => v!.trim().isEmpty ? 'Ingrese descripción' : null,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: categoria,
                    items: ['Vía Pública', 'Alumbrado', 'Seguridad', 'Fuga de Agua']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setModalState(() => categoria = v!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Foto'),
                        onPressed: () async {
                          final f = await ImagePicker().pickImage(source: ImageSource.camera);
                          if (f != null) setModalState(() => foto = f);
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.location_on),
                        label: const Text('GPS'),
                        onPressed: () async {
                          final p = await Geolocator.getCurrentPosition();
                          setModalState(() => pos = p);
                        },
                      ),
                    ],
                  ),
                  if (pos != null) Text('Coordenadas: ${pos!.latitude.toStringAsFixed(3)}, ${pos!.longitude.toStringAsFixed(3)}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate() && pos != null) {
                        final navigator = Navigator.of(context);
                        final nueva = IncidenciaModel(
                          titulo: tituloCtrl.text,
                          descripcion: descCtrl.text,
                          categoria: categoria,
                          rutaFoto: foto?.path,
                          latitud: pos!.latitude,
                          longitud: pos!.longitude,
                          fechaHora: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                        );
                        await context.read<IncidenciaProvider>().agregarIncidencia(nueva);
                        if (mounted) {
                          navigator.pop();
                        }
                      }
                    },
                    child: const Text('Guardar Incidencia'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidenciaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes Móviles - JuanPablo')),
      body: provider.cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.incidencias.length,
              itemBuilder: (ctx, i) {
                final inc = provider.incidencias[i];
                return ListTile(
                  leading: inc.rutaFoto != null ? Image.file(File(inc.rutaFoto!), width: 50, fit: BoxFit.cover) : const Icon(Icons.report),
                  title: Text(inc.titulo),
                  subtitle: Text('${inc.categoria} • ${inc.fechaHora}\n${inc.descripcion}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}