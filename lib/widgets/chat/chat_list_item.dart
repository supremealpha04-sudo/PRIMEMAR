import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/conversation_model.dart';
import '../../core/utils/formatter.dart';
import '../common/avatar.dart';

class ChatListItem extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.conversation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final otherUser = conversation.user1 ?? conversation.user2;

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          UserAvatar(
            imageUrl: otherUser?.profileImageUrl,
            size: 56.w,
            isVerified: otherUser?.isVerified ?? false,
          ),
          if (conversation.isLocked)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock,
                  size: 10.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            otherUser?.fullName ?? otherUser?.username ?? 'Unknown',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textPrimary,
            ),
          ),
          if (otherUser?.isVerified ?? false) ...[
            SizedBox(width: 4.w),
            Icon(Icons.verified, color: AppColors.verified, size: 16.sp),
          ],
        ],
      ),
      subtitle: Text(
        conversation.lastMessageContent ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14.sp,
          color: conversation.unreadCount > 0
              ? (isDark ? AppColors.textDark : AppColors.textPrimary)
              : AppColors.textSecondary,
          fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessageAt != null)
            Text(
              Formatter.date(conversation.lastMessageAt!),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          if (conversation.unreadCount > 0) ...[
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
