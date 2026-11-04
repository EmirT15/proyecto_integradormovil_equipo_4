import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  Future<List<Post>> obtenerPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final List<dynamic> datos = jsonDecode(response.body);

    return datos.take(20).map((json) => Post.fromJson(json)).toList();
  }
}
