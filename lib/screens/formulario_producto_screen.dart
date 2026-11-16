import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/producto_model.dart';
import '../services/inventario_db_service.dart';
import '../services/notification_service.dart';

class FormularioProductoScreen extends StatefulWidget {
  const FormularioProductoScreen({super.key});

  @override
  State<FormularioProductoScreen> createState() => _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _cantCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  XFile? _foto;

  Future<void> _tomarFoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (img != null) setState(() => _foto = img);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final cant = int.parse(_cantCtrl.text.trim());
    final prod = ProductoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      cantidad: cant,
      precio: double.parse(_precioCtrl.text.trim()),
      fotoPath: _foto?.path ?? '',
    );

    await InventarioDbService.insertar(prod);

    // Disparar notificación si el stock ingresado es bajo
    if (cant < 5) {
      await NotificationService.alerteStockBajo(prod.nombre, cant);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del Producto'),
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _skuCtrl,
              decoration: const InputDecoration(labelText: 'Código / SKU'),
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cantCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad Stock'),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio (\$)'),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Foto Producto'),
                ),
                const SizedBox(width: 12),
                if (_foto != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_foto!.path), width: 50, height: 50, fit: BoxFit.cover),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardar,
              child: const Text('Registrar en Inventario'),
            ),
          ],
        ),
      ),
    );
  }
}