import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../media/image_view.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isVerified;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.isVerified = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size.w,
            height: size.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ImageView(
                      imageUrl: imageUrl!,
                      width: size.w,
                      height: size.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.cardLight,
                      child: Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
          if (isVerified)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified,
                  color: AppColors.verified,
                  size: size * 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
