import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/message_model.dart';
import '../../core/utils/formatter.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64.w : 16.w,
          right: isMe ? 16.w : 64.w,
          bottom: 8.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
            bottomRight: Radius.circular(isMe ? 4.r : 16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.mediaUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  message.mediaUrl!,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.content.isNotEmpty) ...[
              if (message.mediaUrl != null) SizedBox(height: 8.h),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: isMe ? Colors.white : (isDark ? AppColors.textDark : AppColors.textPrimary),
                ),
              ),
            ],
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatter.time(message.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isMe
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textSecondary,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14.sp,
                    color: message.isRead ? Colors.white : Colors.white.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
