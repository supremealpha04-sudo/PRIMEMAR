import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/settings_provider.dart';

class ChatSettingsScreen extends ConsumerWidget {
  const ChatSettingsScreen({super.key});

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
          'Chat Settings',
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
            _buildSectionTitle(context, 'Privacy'),
            _buildToggleTile(
              context,
              icon: Icons.lock_outline,
              title: 'Lock Messages',
              subtitle: 'Require PIN/biometric to open chats',
              value: settings.messagesLocked,
              onChanged: (v) => ref.read(settingsProvider.notifier).updateChatSettings(messagesLocked: v),
              isHighlighted: true,
            ),
            if (settings.messagesLocked) ...[
              SizedBox(height: 12.h),
              _buildLockOptions(context),
            ],
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Message Controls'),
            _buildSelectorTile(
              context,
              icon: Icons.message_outlined,
              title: 'Who can message you',
              value: _getMessagePermissionText(settings.whoCanMessage),
              options: ['Everyone', 'Followers only', 'Nobody'],
              onSelected: (value) {
                final map = {'Everyone': 'everyone', 'Followers only': 'followers', 'Nobody': 'nobody'};
                ref.read(settingsProvider.notifier).updateChatSettings(whoCanMessage: map[value]);
              },
            ),
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Read Receipts'),
            _buildToggleTile(
              context,
              icon: Icons.done_all,
              title: 'Read Receipts',
              subtitle: 'Let others see when you\'ve read their messages',
              value: settings.readReceipts,
              onChanged: (v) => ref.read(settingsProvider.notifier).updateChatSettings(readReceipts: v),
            ),
            _buildToggleTile(
              context,
              icon: Icons.more_horiz,
              title: 'Typing Indicator',
              subtitle: 'Show when you\'re typing',
              value: settings.typingIndicator,
              onChanged: (v) => ref.read(settingsProvider.notifier).updateChatSettings(typingIndicator: v),
            ),
            
            SizedBox(height: 32.h),
            _buildSecurityInfo(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
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
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isHighlighted = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
        border: isHighlighted && value
            ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isHighlighted && value ? AppColors.primary : AppColors.textSecondary,
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

  Widget _buildSelectorTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.sp),
        onTap: () => _showOptionsBottomSheet(context, title, options, onSelected),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildLockOptions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lock Options',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildLockOption(
                  context,
                  icon: Icons.pin_outlined,
                  label: 'PIN Lock',
                  onTap: () => _setupPinLock(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildLockOption(
                  context,
                  icon: Icons.fingerprint,
                  label: 'Biometric',
                  onTap: () => _setupBiometric(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: AppColors.success, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End-to-End Encryption',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your messages are secured with industry-standard encryption.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMessagePermissionText(String value) {
    switch (value) {
      case 'followers':
        return 'Followers only';
      case 'nobody':
        return 'Nobody';
      default:
        return 'Everyone';
    }
  }

  void _showOptionsBottomSheet(
    BuildContext context,
    String title,
    List<String> options,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            ...options.map((option) => ListTile(
              title: Text(option),
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _setupPinLock(BuildContext context) {
    // Navigate to PIN setup screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Up PIN'),
        content: const Text('Create a 4-digit PIN to lock your chats.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement PIN setup logic
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _setupBiometric(BuildContext context) {
    // Implement biometric setup
  }
}
