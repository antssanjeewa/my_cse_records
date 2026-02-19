import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/routing/pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

    // If biometric is enabled, we ALWAYS show the login page first for quick access
    if (biometricEnabled) {
      Pages.login.go(context);
      return;
    }

    // Otherwise, check if a session exists to skip login
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      Pages.home.go(context);
    } else {
      Pages.login.go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.background, AppColors.backgroundGradientEnd],
              ),
            ),
          ),
          // Fallback check if background image is available
          SizedBox.expand(
            child: Image.asset(
              AppAssets.background,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Container(color: AppColors.overlayDark),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo_hero',
                  child: Image.asset(
                    AppAssets.logo,
                    width: 120,
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(Icons.trending_up,
                        color: AppColors.primary, size: 80),
                  ),
                ),
                const SizedBox(height: AppSizes.p24),
                Text(
                  AppText.appName,
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSizes.p4),
                const Text(
                  'Your CSE Records',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              children: [
                const Text(
                  'Synchronizing Market Data...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSizes.p12),
                Container(
                  height: 4,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
