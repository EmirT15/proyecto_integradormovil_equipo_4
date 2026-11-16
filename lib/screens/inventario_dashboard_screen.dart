import 'dart:io';
import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/inventario_db_service.dart';
import 'catalogo_api_screen.dart';
import 'formulario_producto_screen.dart';

class InventarioDashboardScreen extends StatefulWidget {
  const InventarioDashboardScreen({super.key});

  @override
  State<InventarioDashboardScreen> createState() => _InventarioDashboardScreenState();
}

class _InventarioDashboardScreenState extends State<InventarioDashboardScreen> {
  List<ProductoModel> _productos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarData();
  }

  Future<void> _cargarData() async {
    setState(() => _cargando = true);
    final items = await InventarioDbService.obtenerProductos();
    setState(() {
      _productos = items;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Inventario'),
        backgroundColor: const Color(0xFF1E1E2C),
        actions: [
          IconButton(
            icon: const Icon(Icons.api),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CatalogoApiScreen()),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _productos.isEmpty
              ? const Center(child: Text('No hay productos en inventario', style: TextStyle(color: Colors.white38)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _productos.length,
                  itemBuilder: (context, index) {
                    final item = _productos[index];
                    return Card(
                      color: const Color(0xFF1E1E2C),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: item.fotoPath.isNotEmpty
                            ? Image.file(File(item.fotoPath), width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.inventory_2, color: Colors.cyanAccent),
                        title: Text(item.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('SKU: ${item.sku} | \$${item.precio}', style: const TextStyle(color: Colors.white70)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.cantidad < 5 ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stock: ${item.cantidad}',
                            style: TextStyle(
                              color: item.cantidad < 5 ? Colors.redAccent : Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormularioProductoScreen()));
          _cargarData();
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Agregar Producto'),
      ),
    );
  }
}