import 'package:flutter_composer/index.dart';

class Item {
  final String name;
  Item(this.name);
}

extension ContextItemExtensions on Context {
  List<Item> get items => get<List<Item>>('items') ?? [];
  void setItems(List<Item> items) => this['items'] = items;
}

void initializeItems() {
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
}
