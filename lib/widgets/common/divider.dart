import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class AppDivider extends StatelessWidget {
  final double indent;
  final double endIndent;
  final double thickness;

  const AppDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      color: isDark ? AppColors.borderDark : AppColors.border,
      thickness: thickness.h,
      indent: indent.w,
      endIndent: endIndent.w,
      height: 1.h,
    );
  }
}
