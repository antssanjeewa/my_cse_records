import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/secure_storage_service.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/biometric_service.dart';
import '../../core/constants/constants.dart';
import '../../core/routing/pages.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.p32),

                // Icon
                Center(
                  child: Container(
                    width: AppSizes.iconHero,
                    height: AppSizes.iconHero,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.r16),
                    ),
                    child: const Icon(Icons.trending_up,
                        color: AppColors.primary, size: AppSizes.iconxxl),
                  ),
                ),

                const SizedBox(height: AppSizes.p24),
                // Text
                Text(
                  AppText.welcomeBack,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSizes.p8),
                Text(
                  AppText.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 16, color: AppColors.textHint),
                ),

                const SizedBox(height: AppSizes.p48),

                if (authViewModel.error != null)
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.r8),
                      border:
                          Border.all(color: Colors.red.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      authViewModel.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: AppSizes.p16),

                // Form
                _buildTextField(
                    controller: _emailController,
                    label: AppText.emailLabel,
                    hint: 'e.g. investor@cse.lk',
                    icon: null),
                const SizedBox(height: AppSizes.p16),
                _buildTextField(
                    controller: _passwordController,
                    label: AppText.passwordLabel,
                    hint: 'Enter your password',
                    icon: Icons.visibility,
                    isPassword: true),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(AppText.forgotPassword,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ),
                ),

                const SizedBox(height: AppSizes.p16),

                ElevatedButton(
                  onPressed: authViewModel.isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          await authViewModel.login(email, password);

                          if (mounted && authViewModel.isAuthenticated) {
                            // Save credentials for future biometric login
                            await getIt<SecureStorageService>()
                                .saveCredentials(email, password);
                            Pages.home.go(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.r12)),
                    textStyle: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: authViewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(AppText.signIn),
                ),

                const SizedBox(height: AppSizes.p32),

                // Biometric
                if (_biometricEnabled)
                  Column(
                    children: [
                      const Text(AppText.quickAccess,
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 14)),
                      const SizedBox(height: AppSizes.p16),
                      InkWell(
                        onTap: () async {
                          final biometricService = getIt<BiometricService>();
                          final secureStorage = getIt<SecureStorageService>();

                          final isAvailable =
                              await biometricService.isBiometricAvailable();

                          if (!isAvailable) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Biometric authentication is not available on this device.')),
                              );
                            }
                            return;
                          }

                          final authenticated =
                              await biometricService.authenticate();
                          if (authenticated) {
                            // Check if we have stored credentials
                            final creds = await secureStorage.getCredentials();
                            if (creds != null) {
                              await authViewModel.login(
                                creds['email']!,
                                creds['password']!,
                              );
                              if (mounted && authViewModel.isAuthenticated) {
                                Pages.home.go(context);
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please sign in with your email and password once to enable quick access.')),
                                );
                              }
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3)),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.fingerprint,
                              size: 36, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p8),
                      const Text(AppText.biometricLogin,
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 12)),
                    ],
                  ),

                const SizedBox(height: AppSizes.p32),
                Center(
                    child: RichText(
                        text: const TextSpan(
                            style: TextStyle(color: AppColors.textHint),
                            children: [
                      TextSpan(text: AppText.noAccount),
                      TextSpan(
                          text: AppText.signUp,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ]))),

                const SizedBox(height: AppSizes.p24),
                // Security Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock,
                        size: 12,
                        color: AppColors.textPrimary.withValues(alpha: 0.5)),
                    const SizedBox(width: 4),
                    Text(AppText.endToEndEncrypted,
                        style: TextStyle(
                            color: AppColors.textPrimary.withValues(alpha: 0.5),
                            fontSize: 10,
                            letterSpacing: 1.0)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required String hint,
      IconData? icon,
      bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: AppSizes.p8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
                borderSide: const BorderSide(color: AppColors.primary)),
            suffixIcon: icon != null
                ? Icon(icon, color: AppColors.textSecondary)
                : null,
            contentPadding: const EdgeInsets.all(AppSizes.p16),
          ),
        ),
      ],
    );
  }
}
