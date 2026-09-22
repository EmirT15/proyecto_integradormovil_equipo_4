import 'package:flutter/material.dart';

import '../models/materia.dart';
import '../widgets/materia_card.dart';
import 'materia_detalle_page.dart';

class MateriasInicioPage extends StatelessWidget {
  const MateriasInicioPage({super.key});

  static const List<Materia> listaMaterias = [
    Materia(
      nombre: 'Programación Móvil',
      semestre: 6,
      creditos: 5,
      descripcion: 'Desarrollo de aplicaciones móviles multiplataforma usando Flutter y Dart.',
    ),
    Materia(
      nombre: 'Bases de Datos',
      semestre: 4,
      creditos: 5,
      descripcion: 'Diseño, modelado e implementación de sistemas gestores de bases de datos relacionales.',
    ),
    Materia(
      nombre: 'Ingeniería de Software',
      semestre: 5,
      creditos: 4,
      descripcion: 'Metodologías de desarrollo, ciclo de vida del software y patrones de diseño.',
    ),
    Materia(
      nombre: 'Redes de Computadoras',
      semestre: 5,
      creditos: 5,
      descripcion: 'Fundamentos de comunicación de datos, modelo OSI, TCP/IP y enrutamiento.',
    ),
    Materia(
      nombre: 'Sistemas Operativos',
      semestre: 4,
      creditos: 4,
      descripcion: 'Gestión de procesos, memoria, almacenamiento y sistemas de archivos.',
    ),
    Materia(
      nombre: 'Estructura de Datos',
      semestre: 3,
      creditos: 5,
      descripcion: 'Listas, pilas, colas, árboles y grafos aplicados a la resolución eficiente de problemas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Materias')),
      body: ListView.builder(
        itemCount: listaMaterias.length,
        itemBuilder: (context, index) {
          final materia = listaMaterias[index];
          return MateriaCard(
            materia: materia,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MateriaDetallePage(materia: materia),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
