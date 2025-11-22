import 'package:flutter_composer/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final composer = context.composer;
    final dataContext = Context()
      ..begin()
      ..setTitle('** Title **')
      ..setName('Flutter')
      ..setCounter(0)
      ..setItems([
        Item('Item 1'),
        Item('Item 2'),
        Item('Item 3'),
      ])
      ..end();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ProvideContext(
        context: dataContext,
        child: Center(
          child: composer.recall(
            'column',
            context: Context()
              ..setChildren(
                [
                  composer.recallText(
                    'You have pushed the button this many times:',
                  ),
                  composer.counter(),
                  composer.greeting(),
                  composer.info(),
                  composer.recall('list:items'),
                ],
              ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dataContext.incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
