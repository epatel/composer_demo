# Flutter Composer

A Flutter project demonstrating the Composer pattern for dynamic widget composition with context-based configuration.

## Features

- **Composer Pattern**: Define and recall widgets dynamically using a registry pattern
- **Context System**: Type-safe context wrapper with fluent API for widget configuration
- **Provider Integration**: Seamless integration with Flutter's Provider package
- **Go Router**: Navigation setup using go_router
- **Comprehensive Testing**: Unit tests, widget tests, and golden tests with proper font rendering

## Architecture

### Composer Pattern

The Composer pattern allows you to register widget builders and recall them later with different contexts:

```dart
// Define a widget
composer.define('greeting', (context) {
  return Text('Hello, ${context.name ?? "World"}!');
});

// Recall the widget with context
final widget = composer.recall('greeting', context: Context()..setName('Flutter'));
```

### Context System

Context is a wrapper around `Map<String, dynamic>` with extension methods for type-safe access:

```dart
final context = Context()
  ..setName('John')
  ..setTitle('Developer')
  ..setColors(ContextColors()..primary = Colors.blue)
  ..setSizes(ContextSizes()..lg = 24.0);
```

### Singleton Management

The Composer uses a factory constructor pattern with test isolation support:

```dart
// In tests
setUp(() {
  Composer.resetForTest();
  initializeComposer();
});
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── router.dart                  # GoRouter configuration
├── pages/
│   └── home_page.dart          # Home page implementation
├── providers/
│   └── counter_provider.dart   # State management
└── composer/
    ├── composer.dart           # Barrel file
    └── src/
        ├── composer.dart       # Core singleton
        ├── context.dart        # Context wrapper
        ├── extensions.dart     # Context & Composer extensions
        └── initializer.dart    # Widget definitions

test/
└── composer/
    ├── composer_test.dart           # Unit tests
    ├── context_test.dart            # Context tests
    ├── composer_widget_test.dart    # Widget tests
    ├── composer_golden_test.dart    # Golden tests
    └── goldens/                     # Golden test images
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0

### Installation

```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/composer/composer_test.dart

# Update golden files
flutter test test/composer/composer_golden_test.dart --update-goldens
```

## Dependencies

### Production
- `flutter`: SDK
- `provider`: ^6.1.5+1 - State management
- `go_router`: ^17.0.0 - Navigation
- `google_fonts`: ^6.3.2 - Font loading
- `cupertino_icons`: ^1.0.8 - iOS icons

### Development
- `flutter_test`: SDK
- `flutter_lints`: ^6.0.0 - Linting rules
- `flutter_test_goldens`: ^0.0.7 - Golden test utilities
- `golden_toolkit`: ^0.15.0 - Roboto font for tests

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: 10 tests for Composer core functionality
- **Context Tests**: 18 tests for Context system
- **Widget Tests**: 11 tests for widget composition
- **Golden Tests**: 7 visual regression tests with real font rendering

### Golden Tests

Golden tests use the `flutter_test_goldens` package to ensure proper font rendering in test snapshots. The tests load the Roboto font from `golden_toolkit` package to avoid the default Ahem font.

Configuration in `test/flutter_test_config.dart`:
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await TestFonts.loadAppFonts();
  return testMain();
}
```

## Code Assessment

See [ASSESSMENT_CODE.md](ASSESSMENT_CODE.md) for a detailed code quality assessment and recommendations.

## License

This project is a demonstration/template and is not published to pub.dev.
