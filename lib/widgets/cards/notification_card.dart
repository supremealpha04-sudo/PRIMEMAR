import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/notification_model.dart';
import '../../core/utils/formatter.dart';
import '../common/avatar.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        imageUrl: notification.actor?.profileImageUrl,
        size: 40.w,
        isVerified: notification.actor?.isVerified ?? false,
      ),
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: notification.actor?.fullName ?? 'Someone',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' ${notification.message}'),
          ],
        ),
      ),
      subtitle: Text(
        Formatter.date(notification.createdAt),
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: notification.isRead
          ? null
          : Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}
