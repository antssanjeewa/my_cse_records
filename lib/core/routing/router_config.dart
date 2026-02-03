import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/portfolio_screen.dart';
import '../app/main_shell.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/transaction_history_screen.dart';
import '../../presentation/screens/add_transaction_screen.dart';
import '../../presentation/screens/cash_screen.dart';
import '../../presentation/screens/manage_stocks_screen.dart';
import '../../presentation/viewmodels/cash_viewmodel.dart';
import '../../presentation/viewmodels/manage_stocks_viewmodel.dart';
import '../di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'pages.dart';
import '../constants/app_colors.dart';

// Placeholder screens
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
  initialLocation: Pages.splash.toPath(),
  routes: [
    GoRoute(
      path: Pages.splash.toPath(),
      name: Pages.splash.toPathName(),
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Pages.login.toPath(),
      name: Pages.login.toPathName(),
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Pages.addTransaction.toPath(),
      name: Pages.addTransaction.toPathName(),
      builder: (context, state) => const AddTransactionScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: Pages.home.toPath(),
          name: Pages.home.toPathName(),
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Pages.portfolio.toPath(),
          name: Pages.portfolio.toPathName(),
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: Pages.watchlist.toPath(),
          name: Pages.watchlist.toPathName(),
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: Pages.transactions.toPath(),
          name: Pages.transactions.toPathName(),
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: Pages.settings.toPath(),
          name: Pages.settings.toPathName(),
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: Pages.cash.toPath(),
          name: Pages.cash.toPathName(),
          builder: (context, state) {
            final user = getIt<SupabaseClient>().auth.currentUser;
            if (user == null) {
              return const LoginScreen(); // or redirect via GoRouter
            }
            return ChangeNotifierProvider(
              create: (context) => CashViewModel(
                repository: getIt(),
                userId: user.id,
              ),
              child: const CashScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.manageStocks.toPath(),
          name: Pages.manageStocks.toPathName(),
          builder: (context, state) => ChangeNotifierProvider(
            create: (context) => ManageStocksViewModel(
              repository: getIt(),
            ),
            child: const ManageStocksScreen(),
          ),
        ),
        GoRoute(
          path: Pages.profile.toPath(),
          name: Pages.profile.toPathName(),
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
