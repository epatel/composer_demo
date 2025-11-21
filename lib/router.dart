import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const HomePage(title: 'Flutter Demo Home Page'),
    ),
  ],
);
