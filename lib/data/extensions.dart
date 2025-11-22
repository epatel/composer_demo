import 'package:flutter_composer/index.dart';

extension InitializerComposerExtensions on Composer {
  Widget recallText(String text) => recall(
    'text',
    context: Context()..setText(text),
  );

  Widget recallSpacing() => recall('spacing');

  Widget greeting() => recall('greeting');
  Widget info() => recall('info');
}

extension ContextItemExtensions on Context {
  List<Item> get items => get<List<Item>>('items') ?? [];
  void setItems(List<Item> items) => this['items'] = items;
}
