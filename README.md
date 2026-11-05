# Proyecto Integrador Móvil - Equipo 4

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

* El nombre debe contener al menos 3 caracteres.
* El correo debe contener el carácter `@`.
* Se validaron los campos del formulario.
* Se agregaron estudiantes a la lista.
* Se eliminó un estudiante de la lista.
* Se probó la aplicación con diferentes tamaños de ventana.

### Pruebas realizadas

Se ejecutaron los siguientes comandos:

```text
dart format .
flutter analyze
flutter test


### Práctica No. 5: Consumo de API REST y procesamiento JSON

## Proyecto Integrador Móvil - Equipo 4

## 1. Descripción del proyecto

Esta práctica consiste en desarrollar una aplicación utilizando Flutter y Dart que permita consumir servicios web mediante API REST, procesar las respuestas en formato JSON y mostrar la información obtenida en una interfaz gráfica.

La aplicación cuenta con cuatro secciones principales: Registro, Usuarios, Publicaciones y Productos. Se utilizan dos servicios REST públicos para obtener y presentar información.

## 2. Objetivo

Consumir servicios REST mediante peticiones HTTP, convertir las respuestas JSON en objetos Dart y representar los diferentes estados de una solicitud, como carga, éxito y error.

Además, aplicar los conocimientos adquiridos en el desarrollo del proyecto integrador móvil.

## 3. Tecnologías utilizadas

- **Flutter:** framework para el desarrollo de aplicaciones multiplataforma.
- **Dart:** lenguaje de programación utilizado por Flutter.
- **HTTP:** paquete para realizar solicitudes a servicios REST.
- **JSON:** formato utilizado para recibir y procesar información.
- **Git:** sistema de control de versiones.
- **GitHub:** plataforma para alojar y administrar el código fuente.
- **Visual Studio Code:** entorno de desarrollo utilizado.

## 4. Requisitos previos

Para ejecutar el proyecto se necesita:

- Flutter SDK instalado.
- Dart SDK compatible con la versión de Flutter.
- Visual Studio Code o un entorno de desarrollo compatible.
- Conexión a Internet.
- Navegador Google Chrome o dispositivo Android configurado.
- Git instalado.
- Dependencia `http` del proyecto.

## 5. Instalación

### 5.1. Clonar el repositorio

Abrir una terminal y ejecutar:

```bash
git clone <URL_DEL_REPOSITORIO>
```

### 5.2. Acceder al proyecto

```bash
cd proyecto_integradormovil_equipo_4
```

### 5.3. Instalar las dependencias

```bash
flutter pub get
```

Este comando descarga las dependencias necesarias definidas en el archivo `pubspec.yaml`.

## 6. Ejecución del proyecto

Para iniciar la aplicación en Google Chrome:

```bash
flutter run -d chrome
```

También se puede ejecutar en un dispositivo o emulador configurado:

```bash
flutter run
```

Es necesario contar con conexión a Internet para consultar los servicios REST.

## 7. Funcionalidades implementadas

La aplicación contiene las siguientes secciones:

### 7.1. Registro

Presenta un formulario para registrar los datos de los alumnos mediante la interfaz de la aplicación.

### 7.2. Usuarios

Consume el endpoint `/users` de JSONPlaceholder y muestra la información de los usuarios obtenidos, incluyendo identificador, nombre y correo electrónico.

### 7.3. Publicaciones

Consume el endpoint `/posts` de JSONPlaceholder y presenta una lista de publicaciones. Incluye:

- Visualización del título y cuerpo de cada publicación.
- Indicador de carga durante la solicitud.
- Manejo de errores.
- Actualización de información mediante `RefreshIndicator`.
- Navegación a una pantalla de detalle al seleccionar una publicación.

### 7.4. Productos

Consume el endpoint `/products` de DummyJSON y presenta información de los productos obtenidos, incluyendo:

- Nombre.
- Descripción.
- Precio.
- Categoría.
- Calificación.
- Imagen del producto.

También incorpora indicador de carga, manejo de errores, opción para reintentar la solicitud y actualización mediante `RefreshIndicator`.

## 8. API REST utilizadas

Se utilizaron dos servicios REST públicos:

| Servicio | Endpoint | Método HTTP | Información |
| JSONPlaceholder | `https://jsonplaceholder.typicode.com users` | GET | Usuarios |
| JSONPlaceholder | `https://jsonplaceholder.typicode.com/posts` | GET | Publicaciones |
| DummyJSON | `https://dummyjson.com/products` | GET | Productos |

### Procesamiento de respuestas JSON

Las respuestas de los servicios se procesan mediante `jsonDecode()`, que permite convertir el contenido JSON en estructuras de datos de Dart.

Posteriormente, se utilizan constructores `fromJson()` para transformar los datos recibidos en objetos de las clases `Usuario`, `Publicacion` y `Producto`.

### Organización del código

El proyecto utiliza una organización por carpetas:

```text
lib/
├── models/
│   ├── usuario.dart
│   ├── publicacion.dart
│   └── producto.dart
│
├── screens/
│   ├── usuarios_page.dart
│   ├── publicaciones_page.dart
│   ├── publicacion_detail_page.dart
│   └── productos_page.dart
│
├── services/
│   └── api_service.dart
│
└── main.dart
```

## 9. Pruebas y validación

Para comprobar el funcionamiento del proyecto se utilizan los siguientes comandos:

### Análisis del código

```bash
dart analyze lib
```

### Ejecución de pruebas automatizadas

```bash
flutter test
```

También se realizan pruebas funcionales para comprobar:

- La navegación entre las secciones.
- La obtención de usuarios desde JSONPlaceholder.
- La obtención de publicaciones y la visualización de su detalle.
- La obtención de productos desde DummyJSON.
- La representación de los estados de carga, éxito y error.
- La actualización de las listas de información.

## 10. Referencias

- Flutter. Fetch data from the internet. https://docs.flutter.dev/cookbook/networking/fetch-data
- Dart. JSON and serialization. https://docs.flutter.dev/data-and-backend/serialization/json
- JSONPlaceholder. Fake Online REST API. https://jsonplaceholder.typicode.com/
- DummyJSON. Products API. https://dummyjson.com/docs/products

---

