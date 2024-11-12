# Prueba Helipagos Mobile

### Descripción

Prueba Helipagos Mobile es una aplicación móvil desarrollada con Flutter que permite a los usuarios explorar y gestionar información relacionada con criptomonedas y NFTs utilizando la API de CoinGecko. La aplicación implementa el patrón BLoC para una gestión eficiente del estado y ofrece una interfaz intuitiva para una experiencia de usuario fluida.

### Características

- **Listado de Criptomonedas:** Visualiza una lista de las principales criptomonedas con datos actualizados.
- **Detalle de Criptomonedas:** Obtiene información detallada de cada criptomoneda seleccionada.
- **Búsqueda de Criptomonedas:** Permite a los usuarios buscar criptomonedas específicas.
- **Listado de NFTs:** Muestra una lista de NFTs disponibles.
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
│ │ └── nft.dart
│ ├── screens/
│ │ ├── coin_detail_screen.dart
│ │ ├── coin_list_screen.dart
│ │ ├── nft_list_screen.dart
│ │ ├── search_screen.dart
│ │ └── splash_screen.dart
│ ├── services/
│ │ └── api_service.dart
│ ├── state/
│ │ └── coin_state.dart
│ └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

### Descripción de Carpetas y Archivos

- **android/:** Configuraciones específicas para la plataforma Android.
- **ios/:** Configuraciones específicas para la plataforma iOS.
- **lib/:** Contiene el código fuente de la aplicación.
  - **blocs/:** Implementación de los BLoCs para criptomonedas y NFTs.
  - **events/:** Definición de los eventos para los BLoCs.
  - **models/:** Modelos de datos para criptomonedas y NFTs.
  - **screens/:** Interfaces de usuario de las diferentes pantallas.
  - **services/:** Servicios para interactuar con APIs externas.
  - **state/:** Definición de los estados para los BLoCs.
  - **main.dart:** Punto de entrada de la aplicación.
- **test/:** Pruebas unitarias y de integración.
- **pubspec.yaml:** Gestión de dependencias y configuraciones del proyecto.
- **README.md:** Este archivo de documentación.
