import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_assets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = true;
  bool _displayPct = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(AppSizes.p8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.r20),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, size: AppSizes.iconMd),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
          ),
        ),
        title: Text(AppText.settings,
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Profile Header
            Container(
              margin: const EdgeInsets.all(AppSizes.p16),
              padding: const EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(AppAssets.userAvatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nimal Perera',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        const Text('Primary Currency: LKR',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14)),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.verified,
                                color: AppColors.primary, size: 16),
                            SizedBox(width: 4),
                            Text('VERIFIED CSE INVESTOR',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Preferences
            _buildSectionHeader('Preferences'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildToggleItem(
                    icon: Icons.dark_mode,
                    label: 'Dark Mode',
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                    isLast: false,
                  ),
                  _buildToggleItem(
                    icon: Icons.query_stats,
                    label: 'Display % vs Absolute',
                    value: _displayPct,
                    onChanged: (v) => setState(() => _displayPct = v),
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Data Management
            const SizedBox(height: 24),
            _buildSectionHeader('Data Management'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildActionItem(
                      icon: Icons.sync,
                      label: 'Manual Price Update',
                      onTap: () {},
                      isLast: false),
                  _buildActionItem(
                      icon: Icons.cloud_upload,
                      label: 'Backup & Restore',
                      onTap: () {},
                      isLast: false),
                  _buildActionItem(
                      icon: Icons.download,
                      label: 'Export to CSV',
                      onTap: () {},
                      isLast: true,
                      isPrimary: true,
                      iconCode:
                          Icons.table_chart), // Using compatible icon for CSV
                ],
              ),
            ),

            // Footer
            const SizedBox(height: AppSizes.p48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.show_chart, color: Colors.grey),
                const SizedBox(width: AppSizes.p8),
                Text('CSE Tracker',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(AppText.appVersion,
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p32),
              child: Text(AppText.marketDataDisclaimer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      height: 1.5)),
            ),
            const SizedBox(height: AppSizes.p16),
            TextButton(
              onPressed: () {},
              child: const Text(AppText.privacyPolicy,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildToggleItem(
      {required IconData icon,
      required String label,
      required bool value,
      required Function(bool) onChanged,
      required bool isLast}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: 4),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.r8)),
            child: Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSizes.p16),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.surfaceLight,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required bool isLast,
      bool isPrimary = false,
      IconData? iconCode}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: isPrimary
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.r8)),
              child: Icon(iconCode ?? icon,
                  color: isPrimary ? AppColors.primary : AppColors.textPrimary,
                  size: AppSizes.iconMd),
            ),
            const SizedBox(width: AppSizes.p16),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: isPrimary
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
            Icon(isPrimary ? Icons.download : Icons.chevron_right,
                color: isPrimary ? AppColors.primary : Colors.grey),
          ],
        ),
      ),
    );
  }
}
