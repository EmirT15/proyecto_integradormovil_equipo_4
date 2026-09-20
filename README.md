# Proyecto Integrador Móvil - Equipo N

## Integrantes
* Emir Manuel Huchin Tzab
* Juan Pablo Moo Uc
* Jesús Alfredo May Brito
* Charly andrey Keb Homa
* Wilberth Alberto Canul Pech

## Planteamiento del Proyecto Integrador
* **Problema:** Explicación breve del problema real a resolver.
* **Usuarios:** Tipo de usuarios finales.
* **Alcance:** Descripción preliminar del software.

## Práctica No. 1: Configuración del Entorno y Primera Aplicación
### Descripción del Proyecto
* **`lib/`**: Contiene todo el código Dart fuente del proyecto (`main.dart`).
* **`pubspec.yaml`**: Archivo de configuración central, dependencias y assets del proyecto.
* **`test/`**: Espacio dedicado a pruebas unitarias y de integración.

### Conceptos Evaluados
* **Hot Reload vs Hot Restart:** Hot Reload inyecta los cambios de código en la máquina virtual de Dart sin perder el estado de la aplicación. Hot Restart destruye el estado guardado, reinicia el ciclo de vida y reejecuta la app desde el método `main()`.

## Práctica No. 3: Formularios y Validación

### Objetivo

Implementar un formulario de registro de estudiantes utilizando Flutter, aplicando validaciones de campos, selección mediante un menú desplegable y una lista dinámica de registros.

### Conceptos utilizados

* **Form:** Agrupa los campos del formulario y permite validar su contenido.
* **GlobalKey<FormState>:** Permite acceder al estado del formulario para ejecutar la validación.
* **TextFormField:** Permite capturar información y aplicar validaciones.
* **DropdownButtonFormField:** Permite seleccionar el semestre.
* **ListView.builder:** Permite mostrar dinámicamente los estudiantes registrados.
* **setState:** Actualiza la interfaz cuando se agrega o elimina un estudiante.
* **LayoutBuilder:** Permite adaptar la interfaz al espacio disponible.

### Validaciones realizadas

* Validación del nombre.
* Validación del correo electrónico.
* Selección del semestre.
* Registro de estudiantes.
* Eliminación de estudiantes.
* Prueba con diferentes tamaños de ventana.

### Pruebas realizadas

Se ejecutaron:

```text
dart format .
flutter analyze
flutter test