import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';
import '../providers/record_provider.dart';
import '../router/router.dart';
import '../utils/theme/theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CompanyProvider()),
          ChangeNotifierProvider(create: (_) => RecordProvider()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          darkTheme: TAppTheme.darkTheme,
          theme: TAppTheme.lightTheme,
          routerConfig: AppRouter().goRouter,
        ));
  }
}
