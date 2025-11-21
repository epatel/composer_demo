import 'package:flutter/material.dart';
import 'composer.dart';
import 'context.dart';

class ContextSizes {
  double sm = 8.0;
  double md = 16.0;
  double lg = 32.0;
}

class ContextColors {
  Color primary = Colors.blue;
  Color secondary = Colors.grey;
  Color accent = Colors.red;
}

extension ContextExtensions on Context {
  void setText(String text) => data['text'] = text;
  void setName(String name) => data['name'] = name;
  void setTitle(String title) => data['title'] = title;
  void setCount(int count) => data['count'] = count;
  void setIsActive(bool isActive) => data['isActive'] = isActive;
  void setData(Map<String, dynamic> newData) => data.addAll(newData);
  void setSizes(ContextSizes sizes) => data['sizes'] = sizes;
  void setColors(ContextColors colors) => data['colors'] = colors;

  String? get text => get<String>('text');
  String? get name => get<String>('name');
  String? get title => get<String>('title');
  int? get count => get<int>('count');
  bool? get isActive => get<bool>('isActive');
  ContextSizes get sizes => get<ContextSizes>('sizes') ?? ContextSizes();
  ContextColors get colors => get<ContextColors>('colors') ?? ContextColors();
}

extension ComposerExtensions on Composer {
  Widget greeting() => recall('greeting');
  Widget info() => recall('info');
}
