import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/post_model.dart';
import '../../core/utils/formatter.dart';
import '../common/avatar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBoost;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBoost,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: UserAvatar(
              imageUrl: post.creator?.profileImageUrl,
              size: 40.w,
              isVerified: post.creator?.isVerified ?? false,
            ),
            title: Row(
              children: [
                Text(
                  post.creator?.fullName ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                if (post.creator?.isVerified ?? false) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.verified, color: AppColors.verified, size: 16.sp),
                ],
              ],
            ),
            subtitle: Text(
              '@${post.creator?.username ?? 'unknown'} · ${Formatter.date(post.createdAt)}',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Icon(Icons.more_vert, color: AppColors.textSecondary),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              post.content,
              style: TextStyle(
                fontSize: 15.sp,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
          ),
          
          // Media
          if (post.mediaUrl != null) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                post.mediaUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200.h,
                    color: AppColors.cardLight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ],
          
          // Actions
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  count: post.commentsCount,
                  onTap: onComment,
                ),
                _buildActionButton(
                  icon: Icons.repeat,
                  count: post.repostsCount,
                  onTap: onShare,
                ),
                _buildActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_outline,
                  count: post.likesCount,
                  color: post.isLiked ? AppColors.error : null,
                  onTap: onLike,
                ),
                _buildActionButton(
                  icon: Icons.bar_chart,
                  count: post.viewsCount,
                  onTap: null,
                ),
                if (onBoost != null)
                  _buildActionButton(
                    icon: Icons.rocket_launch,
                    label: 'Boost',
                    color: AppColors.warning,
                    onTap: onBoost,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    String? label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color ?? AppColors.textSecondary),
          if (count != null) ...[
            SizedBox(width: 4.w),
            Text(
              Formatter.number(count),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (label != null) ...[
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: color ?? AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
