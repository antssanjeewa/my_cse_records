import 'package:firebase_app/app/provider/screenIndexProvider.dart';
import 'package:firebase_app/app/views/home_page.dart';
import 'package:firebase_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ScreenIndexProvider())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        darkTheme: TAppTheme.darkTheme,
        theme: TAppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
