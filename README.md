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