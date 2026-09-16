# Proyecto Integrador Móvil - Equipo 4

## Integrantes
* Emir Manuel Huchin Tzab
* Juan Pablo Moo Uc
* Jesús Alfredo May Brito
* Charly andrey Keb Homa
* Wilberth Alberto Canul Pech

## Planteamiento del Proyecto Integrador
* **Problema:** El personal encargado de la atención psicopedagógica puede tener dificultades para registrar
                organizar y consultar de manera eficiente la información de los estudiantes.
* **Usuarios:** Personal psicopedagógico, orientadores, estudiantes
* **Alcance:** Una herramienta sencilla y centralizada que ayuda al psicólogo a organizar, registrar y dar
               seguimiento al progreso de sus estudiantes.

## Práctica No. 1: Configuración del Entorno y Primera Aplicación
### Descripción del Proyecto
* **`lib/`**: Contiene todo el código Dart fuente del proyecto (`main.dart`).
* **`pubspec.yaml`**: Archivo de configuración central, dependencias y assets del proyecto.
* **`test/`**: Espacio dedicado a pruebas unitarias y de integración.

### Conceptos Evaluados
* **Hot Reload vs Hot Restart:** Hot Reload inyecta los cambios de código en la máquina virtual de Dart sin perder el estado de la aplicación. Hot Restart destruye el estado guardado, reinicia el ciclo de vida y reejecuta la app desde el método `main()`.

## Práctica No. 2: Fundamentos de Dart, Widgets y Estado

### Descripción
Implementación de una calculadora de propinas móvil utilizando `StatefulWidget` para gestionar el estado dinámico de la interfaz en tiempo real.

### Conceptos Clave
* **StatelessWidget vs StatefulWidget:** 
  * `StatelessWidget`: Representa una interfaz estática e inmutable que no mantiene un estado interno mutable a lo largo del tiempo.
  * `StatefulWidget`: Permite mantener datos mutables y reconstruir la interfaz visual dinámicamente mediante llamadas al método `setState()`.
* **Manejo de Estado Local:** Se utiliza `setState()` para recalcular la propina y el total a pagar cada vez que el usuario modifica el campo de consumo o mueve el slider de porcentaje.
* **TextEditingController:** Control de la entrada de texto del usuario, liberando los recursos del sistema adecuadamente en el método `dispose()`.