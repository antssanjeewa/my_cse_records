import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/di/service_locator.dart';
import 'core/routing/router_config.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/portfolio_viewmodel.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style globally
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.light, // dark text for status bar
      systemNavigationBarColor: Color(0xFF101322), // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PortfolioViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
      ],
      child: MaterialApp.router(
        title: 'CSE Portfolio Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1337EC),
          scaffoldBackgroundColor: const Color(0xFF101322),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1337EC),
            secondary: Color(0xFF1337EC),
            background: Color(0xFF101322),
            surface: Color(0xFF191E33),
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
