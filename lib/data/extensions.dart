import 'package:flutter_composer/index.dart';

extension InitializerComposerExtensions on Composer {
  Widget recallText(String text) => recall(
    'text',
    context: Context()..setText(text),
  );

  Widget recallSpacing() => recall('spacing');

  Widget greeting() => recall('greeting');
  Widget info() => recall('info');
  Widget counter() => recall('counter');
}

extension ContextItemExtensions on Context {
  List<Item> get items => get<List<Item>>('items') ?? [];
  void setItems(List<Item> items) => this['items'] = items;
  List<Widget> get children => get<List<Widget>>('children') ?? [];
  void setChildren(List<Widget> children) => this['children'] = children;
}

extension ContextCounterExtensions on Context {
  int get counter => get<int>('count') ?? 0;
  void setCounter(int value) => this['count'] = value;
  void incrementCounter() => this['count'] = counter + 1;
}
