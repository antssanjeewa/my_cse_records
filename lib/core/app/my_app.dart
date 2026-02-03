import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../routing/router_config.dart';
import '../theme/app_theme.dart';
import '../di/app_providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style globally
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.light, // dark text for status bar
      systemNavigationBarColor: AppColors.background, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp.router(
        title: AppText.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}
