import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'orders_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Profile 👤',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 20),

              // Profile Card Header Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF090D16),
                        child: Text(
                          'AG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Atharva Gahine',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'atharva.gahine@example.com',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'SoleStreet Sneakerhead 👟',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Quick Stats Bar
              Row(
                children: [
                  _buildStatCard('Orders', '${appState.orders.length}', isDark, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
                  }),
                  const SizedBox(width: 12),
                  _buildStatCard('Wishlist', '${appState.wishlistIds.length}', isDark),
                  const SizedBox(width: 12),
                  _buildStatCard('Coupons', '3 Active', isDark),
                ],
              ),

              const SizedBox(height: 24),

              // Menu Options List
              _buildMenuItem(
                icon: Icons.local_shipping_outlined,
                title: 'My Orders',
                subtitle: 'Track, view or reorder past purchases',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
                },
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: 'Flat 402, Skyline Towers, Indiranagar',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Default Address: Flat 402, Skyline Towers, Indiranagar, Bengaluru')),
                  );
                },
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                subtitle: 'UPI, Credit Cards & Wallets',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UPI ID: atharva@okaxis connected')),
                  );
                },
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Theme Mode',
                subtitle: isDark ? 'Currently using dark slate theme' : 'Currently using light theme',
                trailing: Switch(
                  value: appState.isDarkMode,
                  activeThumbColor: AppTheme.primaryColor,
                  onChanged: (val) => appState.toggleThemeMode(),
                ),
                onTap: () => appState.toggleThemeMode(),
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Notifications & App Preferences',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                },
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'FAQs, Live Chat & Customer Support',
                onTap: () {
                  _showHelpDialog(context);
                },
                isDark: isDark,
              ),

              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'About SoleStreet',
                subtitle: 'Version 1.0.0 • Sneaker E-Commerce App',
                onTap: () {
                  _showAboutDialog(context);
                },
                isDark: isDark,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, bool isDark, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: AppTheme.cardDecoration(isDark, borderRadius: 18),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(isDark, borderRadius: 18),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'SoleStreet Customer Support 👟\n\n'
          '📧 Email: support@solestreet.in\n'
          '📞 Phone: 1800-419-SOLE\n\n'
          'We operate 24/7 to assist with sneaker sizes, order tracking, and returns.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.sports_basketball, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('SoleStreet'),
          ],
        ),
        content: const Text(
          'SoleStreet — Step Into Your Style 👟\n\n'
          'Built with Flutter 3.44 & Dart 3.12 with Material 3, Provider State Management, and Responsive Grid Architecture.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It!'),
          ),
        ],
      ),
    );
  }
}

