import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.textSecondary,
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
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
