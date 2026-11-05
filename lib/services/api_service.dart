import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/usuario.dart';
import '../models/publicacion.dart';
import '../models/producto.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Obtener usuarios desde la API
  Future<List<Usuario>> obtenerUsuarios() async {
    final respuesta = await http.get(Uri.parse('$baseUrl/users'));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);

      return datos.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los usuarios');
    }
  }

  // Obtener publicaciones desde la API
  Future<List<Publicacion>> obtenerPublicaciones() async {
    final respuesta = await http.get(Uri.parse('$baseUrl/posts'));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);

      return datos.map((json) => Publicacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las publicaciones');
    }
  }

  Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      // Convertimos la respuesta JSON en un mapa.
      final Map<String, dynamic> datos = jsonDecode(response.body);

      // Extraemos la lista de productos.
      final List<dynamic> productosJson = datos['products'];

      // Convertimos cada elemento JSON en un objeto Producto.
      return productosJson
          .map((producto) => Producto.fromJson(producto))
          .toList();
    } else {
      throw Exception('Error al obtener productos: ${response.statusCode}');
    }
  }
}
