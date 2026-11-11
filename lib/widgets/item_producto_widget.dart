import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/producto_model.dart';
import '../providers/producto_provider.dart';

class ItemProductoWidget extends StatelessWidget {
  final ProductoModel producto;

  const ItemProductoWidget({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final formatoFecha = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.shopping_bag),
        ),
        title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Agregado: ${formatoFecha.format(producto.fechaCreacion)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatoMoneda.format(producto.precio),
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<ProductoProvider>().eliminarProducto(producto.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}