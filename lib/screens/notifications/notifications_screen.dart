import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../utils/helpers.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifProvider = context.watch<NotificationProvider>();
    final notifs = notifProvider.notifications;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (notifs.isNotEmpty)
            TextButton(
              onPressed: () {
                notifProvider.markAllAsRead();
              },
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: AppColors.champagneGold,
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications right now',
                      style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We will notify you about price drops on your wishlist items and shipping updates.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = notifs[index];
                return Dismissible(
                  key: Key(notif.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => notifProvider.deleteNotification(notif.id),
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      notifProvider.markAsRead(notif.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: notif.isRead
                            ? (isDark ? AppColors.cardDark : AppColors.cardLight)
                            : (isDark
                                ? AppColors.champagneGoldLight.withValues(alpha: 0.08)
                                : AppColors.blushLight),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: notif.isRead
                              ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                              : AppColors.champagneGold.withValues(alpha: 0.5),
                          width: notif.isRead ? 0.8 : 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getIconBgColor(notif.type),
                            ),
                            child: Icon(
                              _getIconForType(notif.type),
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryRose,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.message,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.4,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppHelpers.formatDateTime(notif.timestamp),
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.local_shipping_outlined;
      case 'wishlist':
        return Icons.favorite_border_rounded;
      case 'promo':
      default:
        return Icons.auto_awesome;
    }
  }

  Color _getIconBgColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.success;
      case 'wishlist':
        return AppColors.primaryRose;
      case 'promo':
      default:
        return AppColors.champagneGold;
    }
  }
}
