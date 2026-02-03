import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../routing/pages.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey, // Slate 400 equivalent
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'Portfolio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                activeIcon: Icon(Icons.show_chart),
                label: 'Watchlist'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(Pages.home.toPath())) return 0;
    if (location.startsWith(Pages.portfolio.toPath())) return 1;
    if (location.startsWith(Pages.watchlist.toPath())) return 2;
    if (location.startsWith(Pages.profile.toPath()) ||
        location.startsWith(Pages.settings.toPath())) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Pages.home.go(context);
        break;
      case 1:
        Pages.portfolio.go(context);
        break;
      case 2:
        Pages.watchlist.go(context);
        break;
      case 3:
        Pages.settings.go(context);
        break;
    }
  }
}
