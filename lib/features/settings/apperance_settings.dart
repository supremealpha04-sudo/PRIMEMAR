import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/settings_provider.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

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
          'Appearance',
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
            _buildSectionTitle(context, 'Theme'),
            _buildThemeSelector(context, ref, settings.theme),
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Text Size'),
            _buildFontSizeSelector(context, ref, settings.fontSize),
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Accessibility'),
            _buildToggleTile(
              context,
              icon: Icons.animation,
              title: 'Reduce Motion',
              subtitle: 'Minimize animations throughout the app',
              value: settings.reduceMotion,
              onChanged: (v) => ref.read(settingsProvider.notifier).updateAppearance(reduceMotion: v),
            ),
            
            SizedBox(height: 32.h),
            _buildPreviewCard(context, settings),
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

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, String currentTheme) {
    final themes = [
      {'value': 'light', 'label': 'Light', 'icon': Icons.wb_sunny_outlined},
      {'value': 'dark', 'label': 'Dark', 'icon': Icons.nights_stay_outlined},
      {'value': 'system', 'label': 'System', 'icon': Icons.settings_suggest_outlined},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.cardDark 
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: themes.map((theme) {
          final isSelected = currentTheme == theme['value'];
          return ListTile(
            leading: Icon(
              theme['icon'] as IconData,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            title: Text(
              theme['label'] as String,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? AppColors.primary 
                    : (Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.textDark 
                        : AppColors.textPrimary),
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: AppColors.primary, size: 24.sp)
                : null,
            onTap: () {
              ref.read(settingsProvider.notifier).updateAppearance(theme: theme['value'] as String);
              ref.read(themeProvider.notifier).setTheme(theme['value'] as String);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFontSizeSelector(BuildContext context, WidgetRef ref, String currentSize) {
    final sizes = ['Small', 'Medium', 'Large'];
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.cardDark 
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: sizes.map((size) {
              final isSelected = currentSize.toLowerCase() == size.toLowerCase();
              return GestureDetector(
                onTap: () => ref.read(settingsProvider.notifier)
                    .updateAppearance(fontSize: size.toLowerCase()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'This is how text will appear in the app',
            style: TextStyle(
              fontSize: _getFontSize(currentSize),
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.textDark 
                  : AppColors.textPrimary,
            ),
          ),
        ],
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

  Widget _buildPreviewCard(BuildContext context, UserSettings settings) {
    final isDark = settings.theme == 'dark' || 
        (settings.theme == 'system' && 
         MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PrimeMar User',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textDark : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '@username',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'This is a preview of how your content will look with the selected appearance settings.',
            style: TextStyle(
              fontSize: _getFontSize(settings.fontSize),
              color: isDark ? AppColors.textDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  double _getFontSize(String size) {
    switch (size) {
      case 'small':
        return 14.sp;
      case 'large':
        return 18.sp;
      default:
        return 16.sp;
    }
  }
}
