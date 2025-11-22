import 'package:flutter_composer/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final composer = Composer();
    initializeComposer(composer);

    return MultiProvider(
      providers: [
        Provider<Composer>.value(value: composer),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
