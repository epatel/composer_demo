import 'package:flutter_composer/index.dart';

void initializeComposer(Composer composer) {
  composer.define(
    'text',
    (context) => Text(
      context.text ?? '<Missing text>',
      style: TextStyle(
        color: context.colors.primary,
        fontSize: context.sizes.lg,
      ),
    ),
  );

  composer.define(
    'greeting',
    (context) => composer.recallText('Hello, ${context.name ?? "World"}!'),
  );

  composer.define(
    'info',
    (context) => Card(
      child: Padding(
        padding: EdgeInsets.all(context.sizes.md),
        child: composer.recallText('Title: ${context.title ?? "No title"}'),
      ),
    ),
  );

  composer.define(
    'spacing',
    (context) => SizedBox(
      height: context.sizes.md,
      width: context.sizes.md,
    ),
  );

  composer.define(
    'list:items',
    (context) {
      final items = context.items;
      return ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(
            items[index].name,
          ),
        ),
      );
    },
  );

  composer.define(
    'column',
    (context) => Column(
      spacing: context.sizes.md,
      children: context.get<List<Widget>>('children') ?? [],
    ),
  );

  composer.define(
    'counter',
    (context) => Builder(
      builder: (context) {
        final counter = context.select(
          (Context context) => context.counter,
        );
        return composer.recallText('$counter');
      },
    ),
  );
}
