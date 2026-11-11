import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../widgets/item_producto_widget.dart';

class PracticaEvaluativaScreen extends StatefulWidget {
  const PracticaEvaluativaScreen({super.key});

  @override
  State<PracticaEvaluativaScreen> createState() => _PracticaEvaluativaScreenState();
}

class _PracticaEvaluativaScreenState extends State<PracticaEvaluativaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductoProvider>().cargarProductos();
    });
  }

  void _mostrarDialogoAgregar() {
    final nombreController = TextEditingController();
    final precioController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: precioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreController.text.trim();
              final precio = double.tryParse(precioController.text) ?? 0.0;
              if (nombre.isNotEmpty && precio > 0) {
                context.read<ProductoProvider>().agregarProducto(nombre, precio);
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arquitectura & Provider - JuanPablo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: provider.cargando
          ? const Center(child: CircularProgressIndicator())
          : provider.productos.isEmpty
              ? const Center(child: Text('No hay productos registrados.'))
              : ListView.builder(
                  itemCount: provider.productos.length,
                  itemBuilder: (context, index) {
                    final prod = provider.productos[index];
                    return ItemProductoWidget(producto: prod);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }
}