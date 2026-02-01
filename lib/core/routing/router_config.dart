import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/portfolio_screen.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/transaction_history_screen.dart';

// Placeholder screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: Center(
          child: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: '/watchlist',
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
