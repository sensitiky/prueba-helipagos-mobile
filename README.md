# Prueba Helipagos Mobile

### Descripción

Token Wave es una aplicación móvil desarrollada con Flutter que permite a los usuarios explorar y gestionar información relacionada con criptomonedas y NFTs utilizando la API de CoinGecko.
La aplicación implementa el patrón BLoC para una gestión eficiente del estado y ofrece una interfaz intuitiva para una experiencia de usuario fluida.

### Características

- **Listado de Criptomonedas:** Visualiza una lista de las principales criptomonedas con datos actualizados.
- **Detalle de Criptomonedas:** Obtiene información detallada de cada criptomoneda seleccionada.
- **Búsqueda de Criptomonedas:** Permite a los usuarios buscar criptomonedas específicas.
- **Listado de NFTs:** Muestra una lista de NFTs disponibles.
- **Detalle de NFTs:** Obtiene información detallada de cada nft seleccionado.
- **Gestión del Estado con BLoC:** Utiliza el patrón BLoC para manejar el estado de la aplicación de manera eficiente.
- **Obfuscación del Código:** Protege el código fuente mediante la obfuscación durante la construcción del APK.
- **Separación de Información de Depuración:** Divide la información de depuración para mejorar la seguridad y el rendimiento.

### Tecnologías Utilizadas

- **Flutter:** Framework para el desarrollo de aplicaciones móviles multiplataforma.
- **Dart:** Lenguaje de programación utilizado en Flutter.
- **BLoC (Business Logic Component):** Patrón para la gestión del estado.
- **CoinGecko API:** API utilizada para obtener datos de criptomonedas y NFTs.
- **HTTP:** Biblioteca para realizar solicitudes HTTP.
- **Equatable:** Paquete para facilitar la comparación de objetos.
- **Unit Testing:** Pruebas unitarias para asegurar la calidad del código.

### Requisitos Previos

- **Flutter SDK:** Asegúrate de tener instalada la última versión de Flutter.
- **Android Studio o VS Code:** IDE recomendado para el desarrollo.
- **Dispositivo o Emulador Android/iOS:** Para ejecutar y probar la aplicación.
- **Cuenta de CoinGecko:** Obtener una clave API si es necesario.

### Configuración de Variables de Entorno

Esta aplicación utiliza variables de entorno para manejar información sensible como claves API.
A continuación se detallan los pasos para configurar correctamente las variables de entorno sin incluir datos sensibles en el código fuente.

1. **Crear el Archivo `.env`**

En la raíz del proyecto, crea un archivo llamado `.env`. Este archivo no debe ser versionado y ya está incluido en el archivo `.gitignore` para evitar su subida al repositorio.

2. **Definir las Variables de Entorno**

Abre el archivo `.env` y define las siguientes variables:

```properties
API_KEY=tu_clave_api_aquí
BASE_URL=https://api.coingecko.com/api/v3
```

<sup>La clave API se encuentra incluida en el Drive con los datos sensibles.</sup>

3. **Generar el Código de Configuración**
   Después de configurar el archivo .env, ejecuta el siguiente comando para generar el archivo env.g.dart necesario:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

_Este comando utilizará el paquete envied para generar las constantes de acceso a las variables de entorno._

4. **Uso de Variables de Entorno en el Código**
   Accede a las variables de entorno en tu código Dart mediante la clase Env. Por ejemplo:

```dart
//import 'package:nombre_de_tu_aplicacion/models/env.dart';
///En el caso de esta aplicación
import 'package:prueba_helipagos_mobile/models/env.dart';

final String apiKey = Env.apiKey;
final String baseUrl = Env.baseUrl;
```

### Uso

1. **Ejecutar la Aplicación en un Emulador o Dispositivo:**

```
flutter run
```

2. **Construir el APK para Producción:**

```
flutter build apk --release
```

3. **Construir el APK con Obsfuscación:**

```
flutter build apk --obfuscate --split-debug-info=./debug_info
```

### Estructura del Proyecto

```
prueba_helipagos_mobile/
├── android/
├── ios/
├── lib/
│ ├── blocs/
│ │ ├── coin_bloc.dart
│ │ └── nft_bloc.dart
│ ├── events/
│ │ ├── coin_event.dart
│ │ └── nft_event.dart
│ ├── models/
│ │ ├── coin.dart
│ │ ├── env.dart
│ │ └── nft.dart
│ ├── screens/
│ │ ├── coin_detail_screen.dart
│ │ ├── coin_list_screen.dart
│ │ ├── nft_detail_screen.dart
│ │ ├── nft_list_screen.dart
│ │ ├── search_screen.dart
│ │ ├── splash_screen.dart
│ │ └── welcome_screen.dart
│ ├── services/
│ │ └── api_service.dart
│ ├── state/
│ │ ├── coin_state.dart
│ │ └── nft_state.dart
│ └── main.dart
├── test/
├── integration_test/
│    └──app_test.dartdart
├── pubspec.yaml
└── README.md
```

### Descripción de Carpetas y Archivos

- **android/:** Configuraciones específicas para la plataforma Android.
- **ios/:** Configuraciones específicas para la plataforma iOS.
- **lib/:** Contiene el código fuente de la aplicación.
  - **blocs/:** Implementación de los BLoCs para criptomonedas y NFTs.
  - **events/:** Definición de los eventos para los BLoCs.
  - **models/:** Modelos de datos para criptomonedas, NFTs y variables de entorno.
  - **screens/:** Interfaces de usuario de las diferentes pantallas.
  - **services/:** Servicios para interactuar con APIs externas.
  - **state/:** Definición de los estados para los BLoCs.
  - **main.dart:** Punto de entrada de la aplicación.
- **test/:** Pruebas unitarias.
- **integration_test/:** Pruebas de integración.
- **pubspec.yaml:** Gestión de dependencias y configuraciones del proyecto.
- **README.md:** Este archivo de documentación.
