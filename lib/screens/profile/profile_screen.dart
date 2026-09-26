import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/compare_provider.dart';
import '../../widgets/size_guide_dialog.dart';
import '../orders/orders_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../notifications/notifications_screen.dart';
import '../compare/compare_screen.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final orderCount = context.watch<OrderProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final compareCount = context.watch<CompareProvider>().compareList.length;

    final user = auth.currentUser;
    final userName = user?.name ?? 'Atharva S.';
    final userEmail = user?.email ?? 'atharva@heera.luxury';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.heroCardGradient : AppColors.softBlushGradient,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.champagneGold.withValues(alpha: 0.2),
                  child: Text(
                    userName.isNotEmpty ? userName[0] : 'S',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.champagneGold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, size: 16, color: AppColors.champagneGold),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: AppColors.luxuryGoldGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HEERA PRIVÉ VIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MY ACCOUNT
          _buildSectionHeader('MY ACCOUNT', isDark),
          Container(
            decoration: _boxDecoration(isDark),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'My Orders',
                    subtitle: '$orderCount orders placed',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Wishlist',
                    subtitle: '$wishlistCount saved items',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const WishlistScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: '${user?.addresses.length ?? 0} delivery locations',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.compare_arrows_rounded,
                    title: 'Compare Pieces',
                    subtitle: compareCount > 0 ? '$compareCount items in comparison' : 'Compare jewelry side-by-side',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CompareScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // PREFERENCES & THEME
          _buildSectionHeader('PREFERENCES', isDark),
          Container(
            decoration: _boxDecoration(isDark),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  // Dark Mode Switch
                  SwitchListTile.adaptive(
                    activeTrackColor: AppColors.champagneGold,
                    secondary: Icon(
                      isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                      color: AppColors.champagneGold,
                      size: 22,
                    ),
                    title: Text(
                      'Dark Obsidian Mode',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: (val) => themeProvider.toggleTheme(),
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Center',
                    subtitle: 'Promos, price drops & orders',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.straighten_outlined,
                    title: 'Jewellery Size Guide',
                    subtitle: 'Rings, chains & bangles measurements',
                    onTap: () => SizeGuideDialog.show(context),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // SUPPORT & ATELIER
          _buildSectionHeader('CONCIERGE & SUPPORT', isDark),
          Container(
            decoration: _boxDecoration(isDark),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Atelier Concierge',
                    subtitle: '24/7 dedicated luxury stylist support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connecting with HEERA Concierge...')),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.shield_outlined,
                    title: 'Authenticity & Warranty Policy',
                    subtitle: '100% certified metals & heritage guarantee',
                    onTap: () {},
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuTile(
                    icon: Icons.info_outline,
                    title: 'About HEERA',
                    subtitle: 'Version 1.0.0 • Where Heritage Meets Elegance',
                    onTap: () {},
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Logout Button
          OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
            label: const Text('SIGN OUT', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Sign Out?'),
                  content: const Text('Are you sure you want to sign out from HEERA?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        auth.logout();
                        Navigator.pop(ctx);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        width: 0.8,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22, color: AppColors.champagneGold),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
      ),
    );
  }
}
