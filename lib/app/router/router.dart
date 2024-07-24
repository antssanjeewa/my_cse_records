import 'package:firebase_app/app/more/screens/more.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter get goRouter => _router;

// GoRouter configuration
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => MoreScreen(),
      ),
      GoRoute(
        name: 'shope',
        path: '/shope',
        builder: (context, state) => MoreScreen(),
      ),
    ],
  );
}
