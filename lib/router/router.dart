import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/company/company_profile_screen.dart';
import '../screens/company/company_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/records/add_record_screen.dart';
import '../screens/records/records_screen.dart';
import 'bottom_nav_bar.dart';
import 'pages.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter get goRouter => _router;

// GoRouter configuration
  final GoRouter _router = GoRouter(
    // initialLocation: '/chat',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // GoRoute(
      //   name: 'home',
      //   path: '/',
      //   builder: (context, state) => HomeScreen(),
      // ),
      // GoRoute(
      //   name: 'shope',
      //   path: '/shope',
      //   // builder: (context, state) => MoreScreen(),
      // ),

      ShellRoute(
        // navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavigationPage(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: Pages.home.toPath(),
            name: Pages.home.toPathName(),
            builder: (context, state) => HomeScreen(),
            routes: [
              GoRoute(
                path: Pages.productDetails.toPath(isSubRoute: true),
                name: Pages.productDetails.toPathName(),
                builder: (context, state) => RecordsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/companies',
            builder: (context, state) => CompanyScreen(),
          ),
          GoRoute(
            path: '/records',
            builder: (context, state) => RecordsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) {
                  return AddRecordScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(),
          ),
          GoRoute(
            path: '/company/:id',
            builder: (context, state) {
              final companyId = state.pathParameters['id']!;
              final companyName = state.queryParameters['name']!;
              return CompanyProfileScreen(companyId: companyId, companyName: companyName);
            },
          ),
        ],
      )
    ],
  );
}
