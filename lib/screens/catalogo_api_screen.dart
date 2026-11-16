import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatalogoApiScreen extends StatefulWidget {
  const CatalogoApiScreen({super.key});

  @override
  State<CatalogoApiScreen> createState() => _CatalogoApiScreenState();
}

class _CatalogoApiScreenState extends State<CatalogoApiScreen> {
  List<dynamic> _productosApi = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final res = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=5'));
      if (res.statusCode == 200) {
        setState(() {
          _productosApi = jsonDecode(res.body);
          _cargando = false;
        });
      }
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Proveedores (API REST)')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _productosApi.length,
              itemBuilder: (context, index) {
                final item = _productosApi[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(item['image'], width: 40, height: 40, fit: BoxFit.contain),
                    title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${item['price']}'),
                  ),
                );
              },
            ),
    );
  }
}