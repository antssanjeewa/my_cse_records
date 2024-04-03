import 'package:firebase_app/app/provider/screenIndexProvider.dart';
import 'package:firebase_app/home/views/home_page.dart';
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.grey,
        ),
        home: const HomePage(),
      ),
    );
  }
}
