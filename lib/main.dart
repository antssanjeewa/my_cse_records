import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/service_locator.dart';
import 'core/routing/router_config.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/portfolio_viewmodel.dart';
import 'presentation/viewmodels/transaction_history_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://koevusjggapfimievpld.supabase.co',
    anonKey: 'sb_publishable_KENbWDLkCcVVtsDr7MuZAg_ojvqONUk',
    // db pass= 3WWQg/Atg/z%i@+
  );

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
      systemNavigationBarColor: AppColors.background, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PortfolioViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
        ChangeNotifierProvider(
            create: (_) => getIt<TransactionHistoryViewModel>()),
      ],
      child: MaterialApp.router(
        title: AppText.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.primary,
            surface: AppColors.surface,
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
