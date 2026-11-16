import 'dart:io';
import 'package:flutter/material.dart';
import '../models/incidencia_model.dart';
import '../services/database_service.dart';
import 'api_sync_screen.dart';
import 'detalle_reporte_screen.dart';
import 'formulario_reporte_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<IncidenciaModel> _reportes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    setState(() => _cargando = true);
    final lista = await DatabaseService.obtenerTodas();
    setState(() {
      _reportes = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Móvil de Incidencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: 'API REST / Sincronización',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApiSyncScreen()),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _reportes.isEmpty
              ? const Center(
                  child: Text(
                    'No hay reportes de incidencias creados.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _reportes.length,
                  itemBuilder: (context, index) {
                    final item = _reportes[index];
                    return Card(
                      child: ListTile(
                        leading: item.fotoPath.isNotEmpty
                            ? Image.file(
                                File(item.fotoPath),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.warning),
                        title: Text(item.titulo),
                        subtitle: Text('${item.categoria} • ${item.fechaHora.toString().split('.')[0]}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleReporteScreen(reporte: item),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormularioReporteScreen()),
          );
          _cargarReportes();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reporte'),
      ),
    );
  }
}