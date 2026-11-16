import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiSyncScreen extends StatefulWidget {
  const ApiSyncScreen({super.key});

  @override
  State<ApiSyncScreen> createState() => _ApiSyncScreenState();
}

class _ApiSyncScreenState extends State<ApiSyncScreen> {
  List<dynamic> _postsRemotos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _consumirApi();
  }

  Future<void> _consumirApi() async {
    try {
      final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'));
      if (res.statusCode == 200) {
        setState(() {
          _postsRemotos = jsonDecode(res.body);
          _cargando = false;
        });
      } else {
        throw 'Error HTTP: ${res.statusCode}';
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API REST Sincronización')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error al conectar: $_error'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _postsRemotos.length,
                  itemBuilder: (context, index) {
                    final item = _postsRemotos[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${item['id']}')),
                        title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(item['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  },
                ),
    );
  }
}