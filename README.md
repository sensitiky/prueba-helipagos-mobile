# TokenWave Mobile

### Description

Token Wave is a mobile application developed with Flutter that allows users to explore and manage information related to cryptocurrencies and NFTs using the CoinGecko API.
The application implements the BLoC pattern for efficient state management and offers an intuitive interface for a smooth user experience.

### Features

- **Cryptocurrency Listing:** View a list of major cryptocurrencies with up-to-date data.
- **Cryptocurrency Details:** Get detailed information for each selected cryptocurrency.
- **Cryptocurrency Search:** Allow users to search for specific cryptocurrencies.
- **NFT Listing:** Display a list of available NFTs.
- **NFT Details:** Get detailed information for each selected NFT.
- **State Management with BLoC:** Uses the BLoC pattern to manage the application's state efficiently.
- **Code Obfuscation:** Protects the source code through obfuscation during APK build.
- **Debug Information Separation:** Splits debug information to improve security and performance.

### Technologies Used

- **Flutter:** Framework for cross-platform mobile application development.
- **Dart:** Programming language used in Flutter.
- **BLoC (Business Logic Component):** Pattern for state management.
- **CoinGecko API:** API used to obtain cryptocurrency and NFT data.
- **HTTP:** Library for making HTTP requests.
- **Equatable:** Package to facilitate object comparison.
- **Json Serializable:** Package for automatic JSON serialization code generation.
- **Envied:** Package for secure environment variable management.
- **Integration Testing:** Integration tests to ensure code quality and final user experience.

### Prerequisites

- **Flutter SDK:** Ensure you have the latest version of Flutter installed.
- **Android Studio or VS Code:** Recommended IDE for development.
- **Android/iOS Device or Emulator:** To run and test the application.
- **CoinGecko Account:** Obtain an API key if necessary.

### Environment Variables Configuration

This application uses environment variables to handle sensitive information such as API keys.
Below are the steps to correctly configure environment variables without including sensitive data in the source code.

1. **Create the `.env` File**

   In the root of the project, create a file named `.env`. This file should not be versioned and is already included in the `.gitignore` file to prevent it from being uploaded to the repository.

2. **Define the Environment Variables**

   Open the `.env` file and define the following variables:

   ```properties
   API_KEY=your_api_key_here
   BASE_URL=https://api.coingecko.com/api/v3
   ```

   <sup>The API key is included in the Drive with sensitive data.</sup>

3. **Generate the Configuration Code**
   After configuring the `.env` file, run the following command to generate the files:

   - **env.g.dart**
   - **coin.g.dart**
   - **nft.g.dart**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   _This command uses the Envied package to generate constants for accessing environment variables. Additionally, it will automatically create code for converting to and from JSON using Dart class annotations._
   <sup>In this repository, the classes for accessing environment variables and the fromJson and toJson conversion classes are already included.</sup>

4. **Using Environment Variables in Code**
   Access environment variables in your Dart code using the Env class. For example:

   ```dart
   //import 'package:your_application/models/env.dart';
   ///In this application
   import 'package:token_wave_mobile/models/env.dart';

   final String apiKey = Env.apiKey;
   final String baseUrl = Env.baseUrl;
   ```

### Usage

1. **Run the Application on an Emulator or Device:**

   ```
   flutter run
   ```

2. **Build the APK for Production:**

   ```
   flutter build apk --release
   ```

3. **Build the APK with Obfuscation:**

   ```
   flutter build apk --obfuscate --split-debug-info=./debug_info
   ```

4. **Perform an Integration Test:**

   <sup>In the root folder of the project</sup>

   ```
   dart run test integration_test/
   ```

### Project Structure

```
token_wave_mobile/
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
├── integration_test/
│    └──app_test.dartdart
├── pubspec.yaml
└── README.md
```

### Description of Folders and Files

- **android/:** Platform-specific configurations for Android.
- **ios/:** Platform-specific configurations for iOS.
- **lib/:** Contains the application's source code.
  - **blocs/:** Implementation of BLoCs for cryptocurrencies and NFTs.
  - **events/:** Definition of events for BLoCs.
  - **models/:** Data models for cryptocurrencies, NFTs, and environment variables.
  - **screens/:** User interfaces for different screens.
  - **services/:** Services to interact with external APIs.
  - **state/:** State definitions for BLoCs.
  - **main.dart:** Entry point of the application.
- **integration_test/:** Integration tests.
- **pubspec.yaml:** Dependency management and project configurations.
- **README.md:** This documentation file.
