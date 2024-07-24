import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => __SplashScreenState();
}

class __SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NavigationToLoginScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: const Center(
        child: Icon(
          Icons.favorite,
          size: 200,
        ),
      ),
    );
  }
}

void NavigationToLoginScreen(BuildContext context) {
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  });
}
