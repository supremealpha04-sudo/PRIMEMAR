import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/user_model.dart';
import '../../core/utils/formatter.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../common/avatar.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.user,
    this.isFollowing = false,
    this.onFollow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        imageUrl: user.profileImageUrl,
        size: 48.w,
        isVerified: user.isVerified,
      ),
      title: Row(
        children: [
          Text(
            user.fullName ?? user.username,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDark : AppColors.textPrimary,
            ),
          ),
          if (user.isVerified) ...[
            SizedBox(width: 4.w),
            Icon(Icons.verified, color: AppColors.verified, size: 16.sp),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? AppColors.textDark.withOpacity(0.7) : AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 4.h),
          Text(
            '${Formatter.number(user.followersCount)} followers',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 100.w,
        child: isFollowing
            ? SecondaryButton(
                text: 'Following',
                height: 36,
                onPressed: onFollow,
              )
            : PrimaryButton(
                text: 'Follow',
                height: 36,
                onPressed: onFollow,
              ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}
