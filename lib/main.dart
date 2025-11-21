import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'package:flutter_composer/composer/composer.dart';
import 'package:flutter_composer/providers/counter_provider.dart';

void main() {
  initializeComposer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: router,
      ),
    );
  }
}
