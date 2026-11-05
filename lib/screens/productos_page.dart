import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/api_service.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final ApiService _apiService = ApiService();

  late Future<List<Producto>> _productosFuture;

  @override
  void initState() {
    super.initState();
    _productosFuture = _apiService.obtenerProductos();
  }

  Future<void> _recargarProductos() async {
    setState(() {
      _productosFuture = _apiService.obtenerProductos();
    });

    try {
      await _productosFuture;
    } catch (_) {
      // El FutureBuilder mostrará el mensaje de error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _recargarProductos,
        child: FutureBuilder<List<Producto>>(
          future: _productosFuture,
          builder: (context, snapshot) {
            // Estado de carga.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            // Estado de error.
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'No se pudieron cargar los productos.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _recargarProductos,
                      child: const Text('Intentar nuevamente'),
                    ),
                  ),
                ],
              );
            }

            // Estado sin datos.
            final productos = snapshot.data ?? [];

            if (productos.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Center(child: Text('No hay productos disponibles.')),
                ],
              );
            }

            // Estado exitoso.
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del producto.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            producto.imagen,
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 35,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Información del producto.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.titulo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                producto.descripcion,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Categoría: ${producto.categoria}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${producto.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(producto.calificacion.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
