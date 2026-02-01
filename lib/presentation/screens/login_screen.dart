import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.p16),
                // Top Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.primary),
                      onPressed: () {},
                    ),
                    const Expanded(
                        child: Text(
                      AppText.loginTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(width: AppSizes.p48), // balance space
                  ],
                ),

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

                // Form
                _buildTextField(
                    label: AppText.emailLabel,
                    hint: 'e.g. investor@cse.lk',
                    icon: null),
                const SizedBox(height: AppSizes.p16),
                _buildTextField(
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
                  onPressed: () {
                    context.go(AppRoutes.home);
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
                  child: const Text(AppText.signIn),
                ),

                const SizedBox(height: AppSizes.p32),

                // Biometric
                Column(
                  children: [
                    const Text(AppText.quickAccess,
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 14)),
                    const SizedBox(height: AppSizes.p16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.fingerprint,
                          size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    const Text(AppText.biometricLogin,
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 12)),
                  ],
                ),

                const SizedBox(height: AppSizes.p32),
                Center(
                    child: RichText(
                        text: TextSpan(
                            style: const TextStyle(color: AppColors.textHint),
                            children: [
                      const TextSpan(text: AppText.noAccount),
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
      {required String label,
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
