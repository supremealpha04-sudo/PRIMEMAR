import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class VerifiedBadge extends StatelessWidget {
  final double size;
  final bool showBorder;

  const VerifiedBadge({
    super.key,
    this.size = 16,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: showBorder
          ? BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            )
          : null,
      child: Icon(
        Icons.verified,
        color: AppColors.verified,
        size: size.sp,
      ),
    );
  }
}
