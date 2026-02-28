import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/settings_provider.dart';
import 'account_settings.dart';
import 'appearance_settings.dart';
import 'chat_settings.dart';
import 'notification_settings.dart';
import 'privacy_settings.dart';
import 'profile_settings.dart';
import 'security_settings.dart';
import 'support.dart';
import 'wallet_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            _buildSectionHeader(context, 'Account'),
            _buildSettingsTile(
              context,
              icon: Icons.person_outline,
              title: AppStrings.profileSettings,
              subtitle: 'Edit profile, username, bio',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.account_circle_outlined,
              title: AppStrings.accountSettings,
              subtitle: 'Email, password, deactivate',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: AppStrings.walletSettings,
              subtitle: 'Balance, transactions, withdrawals',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletSettingsScreen()),
              ),
            ),
            
            _buildSectionHeader(context, 'Preferences'),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.privacySettings,
              subtitle: 'Visibility, online status, tags',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacySettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: AppStrings.notificationSettings,
              subtitle: 'Push notifications, alerts',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.chat_bubble_outline,
              title: AppStrings.chatSettings,
              subtitle: 'Message locks, read receipts',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatSettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.palette_outlined,
              title: AppStrings.appearanceSettings,
              subtitle: 'Theme, font size, motion',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
              ),
            ),
            
            _buildSectionHeader(context, 'Security & Data'),
            _buildSettingsTile(
              context,
              icon: Icons.security_outlined,
              title: AppStrings.securitySettings,
              subtitle: '2FA, biometric, sessions',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SecuritySettingsScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.storage_outlined,
              title: AppStrings.dataStorageSettings,
              subtitle: 'Cache, storage, download data',
              onTap: () => _showDataStorageOptions(context),
            ),
            
            _buildSectionHeader(context, 'Support'),
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: AppStrings.supportHelp,
              subtitle: 'FAQ, contact, report bug',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: AppStrings.about,
              subtitle: 'Version ${AppStrings.appVersion}',
              onTap: () => _showAboutDialog(context),
            ),
            
            SizedBox(height: 24.h),
            _buildLogoutButton(context, ref),
            SizedBox(height: 32.h),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textDark.withOpacity(0.6) : AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDark ? AppColors.textDark.withOpacity(0.7) : AppColors.textSecondary,
          size: 24.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark ? AppColors.textDark.withOpacity(0.5) : AppColors.textSecondary,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right,
          color: isDark ? AppColors.textDark.withOpacity(0.3) : AppColors.textSecondary.withOpacity(0.5),
          size: 20.sp,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmation(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.1),
          foregroundColor: AppColors.error,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).logout();
              Navigator.pop(context);
            },
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showDataStorageOptions(BuildContext context) {
    // Implementation for data storage bottom sheet
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: 'Version ${AppStrings.appVersion} (${AppStrings.buildNumber})',
      applicationIcon: Image.asset('assets/images/logo.png', height: 48),
      children: [
        TextButton(
          onPressed: () {/* Open Terms */},
          child: const Text('Terms of Service'),
        ),
        TextButton(
          onPressed: () {/* Open Privacy */},
          child: const Text('Privacy Policy'),
        ),
      ],
    );
  }
}
