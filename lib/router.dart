import 'package:flutter_composer/index.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const HomePage(title: 'Flutter Demo Home Page'),
    ),
  ],
);
