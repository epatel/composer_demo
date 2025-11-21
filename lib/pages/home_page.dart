import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_composer/composer/composer.dart';
import 'package:flutter_composer/providers/counter_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ProvideContext(
        context: Context()
          ..setTitle('** Title **')
          ..setName('Flutter'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              Consumer<CounterProvider>(
                builder: (context, counterProvider, child) {
                  return Text(
                    '${counterProvider.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              composer.recallSpacing(),
              composer.greeting(),
              composer.recallSpacing(),
              composer.info(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterProvider>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
