# Flutter Composer

A Flutter project demonstrating the Composer pattern for dynamic widget composition with context-based configuration, dependency injection, and optimized reactive updates.

## Features

- **Composer Pattern**: Define and recall widgets dynamically using a registry pattern
- **Dependency Injection**: Provider-based architecture for flexible, testable code
- **Context System**: Type-safe context wrapper with runtime type checking and fluent API
- **Transaction Batching**: Optimize bulk updates with `begin()`/`end()` methods
- **Optimized Reactivity**: Targeted widget rebuilds using `context.select()`
- **Runtime Type Safety**: `ContextTypeMismatchError` thrown on type mismatches with helpful messages
- **Transaction Safety**: `ContextTransactionError` for transaction misuse detection
- **Provider Integration**: Seamless integration with Flutter's Provider package
- **Go Router**: Navigation setup using go_router
- **Comprehensive Testing**: 54 tests including unit tests, widget tests, and golden tests with proper font rendering
- **Interactive Demo**: Counter example demonstrating reactive updates

## Quick Start

```dart
// Create and initialize composer
final composer = Composer();
initializeComposer(composer);

// Provide composer via Provider
Provider<Composer>.value(value: composer)

// Use composer in widgets
final composer = context.composer;

// Create context with transaction batching
final dataContext = Context()
  ..begin()
  ..setTitle('Welcome')
  ..setName('Flutter')
  ..setCounter(0)
  ..end();  // Single notification for all updates

// Recall widgets
composer.greeting()
composer.counter()
composer.recall('list:items')
```

## Architecture

### Composer Pattern

The Composer pattern allows you to register widget builders and recall them later with different contexts:

```dart
// Define a widget
composer.define('greeting', (context) {
  return Text('Hello, ${context.name ?? "World"}!');
});

// Recall the widget with context
final widget = composer.recall(
  'greeting', 
  context: Context()..setName('Flutter')
);

// Or use extension methods for convenience
final widget = composer.greeting();
```

### Context System

Context is a type-safe wrapper with runtime type checking via internal typed value storage. Extension methods provide a fluent API:

```dart
final context = Context()
  ..setName('John')
  ..setTitle('Developer')
  ..setColors(ContextColors()..primary = Colors.blue)
  ..setSizes(ContextSizes()..lg = 24.0);

// Type-safe retrieval - throws ContextTypeMismatchError on mismatch
final name = context.get<String>('name'); // OK
final count = context.get<int>('name');   
// Throws: ContextTypeMismatchError: Type mismatch for key "name": 
//         expected int but got String
```

### Transaction Batching

Optimize performance when updating multiple context values:

```dart
// Without batching: 4 notifications
context['name'] = 'John';
context['age'] = 30;
context['city'] = 'NYC';
context['active'] = true;

// With batching: 1 notification
context.begin();
context['name'] = 'John';
context['age'] = 30;
context['city'] = 'NYC';
context['active'] = true;
context.end();  // Single notification

// Or with cascade notation
final context = Context()
  ..begin()
  ..setName('John')
  ..setTitle('Developer')
  ..setCounter(0)
  ..end();
```

### Optimized Reactivity

Use `context.select()` for targeted widget rebuilds:

```dart
// Only rebuilds when counter changes, not on any context update
composer.define(
  'counter',
  (context) => Builder(
    builder: (context) {
      final counter = context.select(
        (Context context) => context.counter,
      );
      return Text('$counter');
    },
  ),
);
```

### Dependency Injection

The Composer uses Provider for dependency injection, making it testable and flexible:

```dart
// In main.dart
final composer = Composer();
initializeComposer(composer);

MultiProvider(
  providers: [
    Provider<Composer>.value(value: composer),
  ],
  child: MaterialApp.router(...)
)

// In widgets
final composer = context.composer;  // BuildContext extension

// In tests - each test creates its own instance
test('should work', () {
  final composer = Composer();
  // Test in isolation
});
```

## Project Structure

```
lib/
├── main.dart                    # App entry point with Provider setup
├── router.dart                  # GoRouter configuration
├── index.dart                   # Barrel file for exports
├── pages/
│   └── home_page.dart          # Interactive counter demo
├── data/
│   ├── item.dart               # Data models
│   ├── extensions.dart         # Composer & Context extensions
│   └── initilizers.dart        # Widget definitions
└── composer/
    ├── composer.dart           # Barrel file
    └── src/
        ├── composer.dart       # Core Composer class
        ├── context.dart        # Context wrapper with transactions
        └── extensions.dart     # Context extensions (sizes, colors)

test/
└── composer/
    ├── composer_test.dart           # Unit tests (6 tests)
    ├── context_test.dart            # Context tests (23 tests)
    ├── composer_widget_test.dart    # Widget tests (18 tests)
    ├── composer_golden_test.dart    # Golden tests (7 tests)
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

The app demonstrates an interactive counter using the Composer pattern with optimized reactivity.

### Running Tests

```bash
# Run all tests (54 tests)
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/composer/composer_test.dart

# Update golden files
flutter test test/composer/composer_golden_test.dart --update-goldens
```

## Widget Definitions

The project includes several pre-defined widgets in `data/initilizers.dart`:

| Widget | Description |
|--------|-------------|
| `text` | Styled text with context colors/sizes |
| `greeting` | Personalized greeting message |
| `info` | Card with title information |
| `spacing` | Vertical spacing widget |
| `list:items` | List view for Item objects |
| `column` | Column with dynamic children and spacing |
| `counter` | Counter display with optimized updates |

### Extension Methods

```dart
// Composer extensions
composer.recallText('Hello')
composer.recallSpacing()
composer.greeting()
composer.info()
composer.counter()

// Context extensions
context.setName('Flutter')
context.setTitle('Title')
context.setCounter(0)
context.incrementCounter()
context.setItems([Item('1'), Item('2')])
context.setChildren([widget1, widget2])
```

## Dependencies

### Production
- `flutter`: SDK
- `provider`: ^6.1.5+1 - State management and dependency injection
- `go_router`: ^17.0.0 - Navigation
- `google_fonts`: ^6.3.2 - Font loading
- `cupertino_icons`: ^1.0.8 - iOS icons

### Development
- `flutter_test`: SDK
- `flutter_lints`: ^6.0.0 - Linting rules
- `flutter_test_goldens`: ^0.0.7 - Golden test utilities
- `golden_toolkit`: ^0.15.0 - Roboto font for tests

## Testing

The project includes comprehensive test coverage (**54 tests total** - all passing ✅):

- **Unit Tests** (6 tests): Composer core functionality
  - Define/recall widgets
  - Error handling for undefined widgets
  - Widget listing and introspection
  - Clear and undefine operations
  - Test isolation

- **Context Tests** (23 tests): Context system
  - Data storage and retrieval
  - Parent context inheritance
  - Type-safe getters with `ContextTypeMismatchError`
  - Extension methods (setters/getters)
  - Transaction batching (`begin()`/`end()`)
  - Transaction error handling
  - Operator overloading

- **Widget Tests** (18 tests): Widget composition
  - Widget recall with context
  - Provider integration
  - Nested contexts
  - Composition (widgets recalling other widgets)
  - Context reactivity (ChangeNotifier)
  - Initializer widget definitions

- **Golden Tests** (7 tests): Visual regression testing
  - Text widget with default/custom styling
  - Greeting widget with/without name
  - Info widget with title
  - Full composition
  - Theme-styled composition
  - Proper font rendering (Roboto via golden_toolkit)

### Golden Tests

Golden tests use the `flutter_test_goldens` package to ensure proper font rendering in test snapshots. The tests load the Roboto font from `golden_toolkit` package to avoid the default Ahem font (blue rectangles).

Configuration in `test/flutter_test_config.dart`:
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await TestFonts.loadAppFonts();
  return testMain();
}
```

## Performance Optimizations

### Transaction Batching
- Use `begin()`/`end()` to batch multiple context updates
- Triggers single notification instead of multiple rebuilds
- Ideal for initializing context with multiple values

### Optimized Reactivity
- Use `context.select()` for targeted widget rebuilds
- Only rebuilds when selected value changes
- Prevents unnecessary rebuilds from unrelated context updates

### Example:
```dart
// Counter only rebuilds when counter value changes
final counter = context.select((Context ctx) => ctx.counter);
```

## Error Handling

### ContextTypeMismatchError
Thrown when retrieving a value with wrong type:
```dart
context['name'] = 'Flutter';
context.get<int>('name');
// Throws: ContextTypeMismatchError: Type mismatch for key "name": 
//         expected int but got String
```

### ContextTransactionError
Thrown when transaction methods are misused:
```dart
context.end();  // No matching begin()
// Throws: ContextTransactionError: end() called without matching begin()
```

### ArgumentError
Thrown when recalling undefined widget:
```dart
composer.recall('undefined-widget');
// Throws: ArgumentError: No widget defined with name: undefined-widget
```

## Code Quality

- **Architecture Grade: A**
- **Overall Rating: 9.0/10**
- **Zero Linter Errors**
- **Production Ready**

See [ASSESSMENT_CODE.md](ASSESSMENT_CODE.md) for detailed code quality assessment, architectural decisions, and design pattern analysis.

## Key Design Patterns

1. **Dependency Injection** - Composer provided via Provider
2. **Builder Pattern** - Function-based widget construction
3. **Registry Pattern** - Named widget storage and retrieval
4. **Hierarchical Context** - Parent-child context chain
5. **Extension Methods** - API augmentation for fluent interface
6. **Type Wrapper** - Runtime type preservation via `_TypedValue<T>`
7. **Transaction/Unit of Work** - Batch updates with single notification
8. **Observer Pattern** - ChangeNotifier for reactive updates

## Best Practices Demonstrated

- ✅ Dependency injection over singletons
- ✅ Type-safe context management
- ✅ Comprehensive test coverage (54 tests)
- ✅ Transaction batching for performance
- ✅ Optimized reactivity with selective updates
- ✅ Golden tests with proper fonts
- ✅ Clean architecture and separation of concerns
- ✅ Provider integration for state management
- ✅ Extension methods for fluent API
- ✅ Helpful error messages

## Example Usage

See `lib/pages/home_page.dart` for a complete example of:
- Creating context with transaction batching
- Using Composer extensions
- Providing context to widget tree
- Interactive counter with optimized updates
- FloatingActionButton integration

## License

This project is a demonstration/template and is not published to pub.dev.

## Contributing

This is a demonstration project showcasing Flutter best practices and architectural patterns. Feel free to use it as a reference or template for your own projects.
