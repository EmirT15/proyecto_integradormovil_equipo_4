import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../models/incidencia_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class FormularioReporteScreen extends StatefulWidget {
  const FormularioReporteScreen({super.key});

  @override
  State<FormularioReporteScreen> createState() => _FormularioReporteScreenState();
}

class _FormularioReporteScreenState extends State<FormularioReporteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _categoria = 'Vía Pública';

  XFile? _foto;
  Position? _posicion;
  bool _obteniendoGPS = false;

  Future<void> _tomarFoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 75);
    if (file != null) setState(() => _foto = file);
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _obteniendoGPS = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() => _posicion = pos);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener ubicación: $e')),
        );
      }
    } finally {
      setState(() => _obteniendoGPS = false);
    }
  }

  Future<void> _guardarReporte() async {
    if (!_formKey.currentState!.validate()) return;
    if (_foto == null || _posicion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes incluir fotografía y ubicación GPS')),
      );
      return;
    }

    final reporte = IncidenciaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      categoria: _categoria,
      fotoPath: _foto!.path,
      latitud: _posicion!.latitude,
      longitud: _posicion!.longitude,
      fechaHora: DateTime.now(),
    );

    await DatabaseService.insertar(reporte);

    // Disparar notificación local requerida por el manual
    await NotificationService.mostrarNotificacion(
      id: DateTime.now().second,
      titulo: 'Reporte Guardado Exitosamente',
      cuerpo: 'Se registró "${reporte.titulo}" localmente.',
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Reporte')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título de la Incidencia'),
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descripción detallada'),
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              items: ['Vía Pública', 'Alumbrado', 'Basura', 'Seguridad'].map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) => setState(() => _categoria = v!),
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto'),
                ),
                const SizedBox(width: 12),
                if (_foto != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_foto!.path), width: 50, height: 50, fit: BoxFit.cover),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _obteniendoGPS ? null : _obtenerUbicacion,
                  icon: const Icon(Icons.my_location),
                  label: Text(_obteniendoGPS ? 'Obteniendo GPS...' : 'Obtener Coordenadas'),
                ),
                const SizedBox(width: 12),
                if (_posicion != null)
                  Expanded(
                    child: Text(
                      'Lat: ${_posicion!.latitude.toStringAsFixed(4)}\nLng: ${_posicion!.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardarReporte,
              child: const Text('Guardar Incidencia'),
            ),
          ],
        ),
      ),
    );
  }
}