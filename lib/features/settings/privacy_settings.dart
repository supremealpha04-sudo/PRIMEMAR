import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/settings_provider.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Privacy',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildSectionTitle(context, 'Account Privacy'),
            _buildToggleTile(
              context,
              title: 'Private Account',
              subtitle: 'Only approved followers can see your posts',
              value: settings.isPrivate,
              onChanged: (value) => ref.read(settingsProvider.notifier).updatePrivacy(isPrivate: value),
            ),
            SizedBox(height: 24.h),
            
            _buildSectionTitle(context, 'Activity Status'),
            _buildToggleTile(
              context,
              title: 'Show Online Status',
              subtitle: 'Let people see when you\'re active',
              value: settings.showOnline,
              onChanged: (value) => ref.read(settingsProvider.notifier).updatePrivacy(showOnline: value),
            ),
            SizedBox(height: 24.h),
            
            _buildSectionTitle(context, 'Interactions'),
            _buildToggleTile(
              context,
              title: 'Allow Profile Views',
              subtitle: 'Let non-followers view your profile',
              value: settings.allowProfileView,
              onChanged: (value) => ref.read(settingsProvider.notifier).updatePrivacy(allowProfileView: value),
            ),
            _buildToggleTile(
              context,
              title: 'Allow Message Requests',
              subtitle: 'Receive messages from non-followers',
              value: settings.allowMessageRequest,
              onChanged: (value) => ref.read(settingsProvider.notifier).updatePrivacy(allowMessageRequest: value),
            ),
            _buildToggleTile(
              context,
              title: 'Allow Tagging',
              subtitle: 'Others can tag you in posts',
              value: settings.allowTag,
              onChanged: (value) => ref.read(settingsProvider.notifier).updatePrivacy(allowTag: value),
            ),
            
            SizedBox(height: 32.h),
            _buildPrivacyInfoCard(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
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
            color: AppColors.textSecondary,
          ),
        ),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }

  Widget _buildPrivacyInfoCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Your privacy is important. These settings control who can see your content and interact with you on PrimeMar.',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? AppColors.textDark.withOpacity(0.8) : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
