import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/admin_model.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final adminRole = AdminRole.fromString(role);
    
    Color color;
    switch (adminRole) {
      case AdminRole.superAdmin:
        color = Colors.purple;
        break;
      case AdminRole.financeAdmin:
        color = Colors.green;
        break;
      case AdminRole.reserveAdmin:
        color = Colors.orange;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        adminRole.displayName,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
