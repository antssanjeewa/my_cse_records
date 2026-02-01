import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'router_config.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/portfolio_viewmodel.dart';

void main() {
  setupLocator();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PortfolioViewModel>()),
      ],
      child: MaterialApp.router(
        title: 'CSE Portfolio Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1337EC),
          scaffoldBackgroundColor: const Color(0xFF101322),
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF1337EC),
            background: const Color(0xFF101322),
            surface: const Color(0xFF191E33),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
