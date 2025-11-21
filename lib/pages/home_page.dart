import 'package:flutter_composer/index.dart';

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
          ..setName('Flutter')
          ..setItems([
            Item('Item 1'),
            Item('Item 2'),
            Item('Item 3'),
          ]),
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
              composer.recall('list:items'),
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
