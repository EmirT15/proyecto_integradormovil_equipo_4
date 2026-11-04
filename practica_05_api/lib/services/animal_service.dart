import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/animal.dart';

class AnimalService {
  Future<List<Animal>> obtenerAnimales() async {
    final uri = Uri.https('api.inaturalist.org', '/v1/observations', {
      'place_id': '6793',
      'iconic_taxa[]': 'Animalia',
      'has[]': 'photos',
      'per_page': '20',
      'locale': 'es',
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final List<dynamic> resultados = decoded['results'] ?? [];

      return resultados
          .map((json) => Animal.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener animales: ${response.statusCode}');
    }
  }
}
