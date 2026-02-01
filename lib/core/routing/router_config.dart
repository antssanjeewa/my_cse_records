import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/portfolio_screen.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/transaction_history_screen.dart';
import '../constants/app_routes.dart';
import '../constants/app_colors.dart';

// Placeholder screens - Updated to use Constants
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
          child: Text(title,
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 20))),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.portfolio,
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: AppRoutes.watchlist,
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
