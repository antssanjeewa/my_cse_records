import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: const Color(0xFF101322), // background-dark
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        title: Text('Settings',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Profile Header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF191E33), // surface dark
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF323B67)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF1337EC), width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAIXKQII4qHZEFY2upDzpqXzGpInlShoikoTAOYxcFY1NUDIud7vvlGpcpHm5epoDjdPPFCEdN3vtcGTNRHnvYn81SzlMbzva2JoGYWagPMEbg0EaOYPw_bX5LHcD550wt-oOYPCdGTbPlWYlaBc7ZYvLs0p2UWRGal9xmnsGtBee3fAytdKb7hntKnz3zYvtwxc82V2_dkKt5mJHcoU9_AAZRwSp8iSKSGRkebVHnzT_9PLW_veFsO81mSDO3fi7XY16ik9qogn1w'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nimal Perera',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 2),
                        const Text('Primary Currency: LKR',
                            style: TextStyle(
                                color: Color(0xFF929BC9), fontSize: 14)),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.verified,
                                color: Color(0xFF1337EC), size: 16),
                            SizedBox(width: 4),
                            Text('VERIFIED CSE INVESTOR',
                                style: TextStyle(
                                    color: Color(0xFF1337EC),
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF191E33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF323B67)),
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF191E33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF323B67)),
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
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.show_chart, color: Colors.grey),
                const SizedBox(width: 8),
                Text('CSE Tracker',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0 (Build 2024.11)',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                  'Market data provided by Colombo Stock Exchange.\nData delayed by up to 15 minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF929BC9), fontSize: 10, height: 1.5)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Privacy Policy & Terms',
                  style: TextStyle(
                      color: Color(0xFF1337EC),
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
                  color: Color(0xFF929BC9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)
              .copyWith(color: const Color(0xFF929BC9))),
    );
  }

  Widget _buildToggleItem(
      {required IconData icon,
      required String label,
      required bool value,
      required Function(bool) onChanged,
      required bool isLast}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFF323B67))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFF232948),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF1337EC), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1337EC),
            activeTrackColor:
                const Color(0xFF232948), // Inactive track color sort of
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFF323B67))),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: isPrimary
                      ? const Color(0xFF1337EC).withOpacity(0.1)
                      : const Color(0xFF232948),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(iconCode ?? icon,
                  color: isPrimary ? const Color(0xFF1337EC) : Colors.white,
                  size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        color:
                            isPrimary ? const Color(0xFF1337EC) : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
            Icon(isPrimary ? Icons.download : Icons.chevron_right,
                color: isPrimary ? const Color(0xFF1337EC) : Colors.grey),
          ],
        ),
      ),
    );
  }
}
