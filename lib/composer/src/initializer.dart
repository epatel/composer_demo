import 'package:flutter/material.dart';
import 'composer.dart';
import 'context.dart';
import 'extensions.dart';

extension InitializerComposerExtensions on Composer {
  Widget recallText(String text) => recall(
    'text',
    context: Context()..setText(text),
  );

  Widget recallSpacing() => recall('spacing');
}

void initializeComposer() {
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
    (context) => SizedBox(height: context.sizes.md),
  );
}
