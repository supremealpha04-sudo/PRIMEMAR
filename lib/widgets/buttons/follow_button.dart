import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const FollowButton({
    super.key,
    required this.isFollowing,
    this.onPressed,
    this.width = 100,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isFollowing ? Colors.transparent : AppColors.primary,
          foregroundColor: isFollowing ? AppColors.textPrimary : Colors.white,
          side: isFollowing ? const BorderSide(color: AppColors.border) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
