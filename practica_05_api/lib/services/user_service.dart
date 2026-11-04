import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  Future<List<Usuario>> obtenerUsuarios() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final List<dynamic> datos = jsonDecode(response.body);

    return datos.map((json) => Usuario.fromJson(json)).toList();
  }
}
