import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderUpdatesEnabled = true;
  bool _promotionalAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              // Theme Switch Card
              Container(
                decoration: AppTheme.cardDecoration(isDark, borderRadius: 18),
                child: SwitchListTile(
                  title: Text(
                    'Dark Theme Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                    ),
                  ),
                  subtitle: Text(
                    isDark ? 'Currently using dark slate theme' : 'Currently using light theme',
                    style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  activeThumbColor: AppTheme.primaryColor,
                  value: appState.isDarkMode,
                  onChanged: (val) {
                    appState.toggleThemeMode();
                  },
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: AppTheme.cardDecoration(isDark, borderRadius: 18),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Push Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Receive drop & sale notifications',
                        style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                      ),
                      activeThumbColor: AppTheme.primaryColor,
                      value: _notificationsEnabled,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                    SwitchListTile(
                      title: Text(
                        'Order Status Updates',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Real-time tracking notifications',
                        style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                      ),
                      activeThumbColor: AppTheme.primaryColor,
                      value: _orderUpdatesEnabled,
                      onChanged: (val) => setState(() => _orderUpdatesEnabled = val),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                    SwitchListTile(
                      title: Text(
                        'Promotional Alerts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Coupons & discount alerts',
                        style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                      ),
                      activeThumbColor: AppTheme.primaryColor,
                      value: _promotionalAlertsEnabled,
                      onChanged: (val) => setState(() => _promotionalAlertsEnabled = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Data & Storage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: AppTheme.cardDecoration(isDark, borderRadius: 18),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cleaning_services_outlined, color: AppTheme.primaryColor, size: 20),
                  ),
                  title: Text(
                    'Clear Image Cache',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Frees up local temporary disk space (12.4 MB)',
                    style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cache cleared successfully! ✨')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

