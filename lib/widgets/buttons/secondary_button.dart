import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.textDark : AppColors.textPrimary,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
