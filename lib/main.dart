import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const RegistroPage(),
  );
}

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});
  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final correo = TextEditingController();
  String semestre = '1';
  final List<String> alumnos = [];
  void guardar() {
    if (formKey.currentState!.validate()) {
      setState(() {
        alumnos.add('${nombre.text} | ${correo.text} | Sem. $semestre');
        nombre.clear();
        correo.clear();
        semestre = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Registro de estudiantes')),
    body: LayoutBuilder(
      builder: (context, c) {
        final ancho = c.maxWidth > 700 ? 600.0 : c.maxWidth;
        return Center(
          child: SizedBox(
            width: ancho,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nombre,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                          ),
                          validator: (v) => v == null || v.trim().length < 3
                              ? 'Escribe un nombre válido'
                              : null,
                        ),
                        TextFormField(
                          controller: correo,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                          ),
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Correo inválido',
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: semestre,
                          items: List.generate(9, (i) => '${i + 1}')
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text('$s°'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => semestre = v!,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: guardar,
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: alumnos.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(alumnos[i]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(() => alumnos.removeAt(i)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
