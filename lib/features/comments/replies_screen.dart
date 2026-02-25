import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/comment_model.dart';
import '../../core/providers/comment_provider.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/common/avatar.dart';
import '../../widgets/common/loading.dart';

class RepliesScreen extends ConsumerWidget {
  final CommentModel comment;

  const RepliesScreen({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesAsync = ref.watch(commentRepliesProvider(comment.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Replies'),
      ),
      body: Column(
        children: [
          // Parent Comment
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.border,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(
                  imageUrl: comment.user?.profileImageUrl,
                  size: 40,
                  isVerified: comment.user?.isVerified ?? false,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.user?.username ?? 'unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textDark : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            Helpers.formatTime(comment.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        comment.content,
                        style: TextStyle(
                          color: isDark ? AppColors.textDark : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Replies List
          Expanded(
            child: repliesAsync.when(
              data: (replies) {
                if (replies.isEmpty) {
                  return const Center(
                    child: Text('No replies yet'),
                  );
                }
                return ListView.builder(
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    final reply = replies[index];
                    return _buildReplyItem(reply, isDark);
                  },
                );
              },
              loading: () => const LoadingList(itemCount: 5),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildReplyInput(context, ref),
    );
  }

  Widget _buildReplyItem(ReplyModel reply, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            imageUrl: reply.user?.profileImageUrl,
            size: 36,
            isVerified: reply.user?.isVerified ?? false,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reply.user?.username ?? 'unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: isDark ? AppColors.textDark : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      Helpers.formatTime(reply.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  reply.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      reply.likesCount.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.borderDark
                  : AppColors.border,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;
                
                await ref.read(commentServiceProvider).addReply(
                  commentId: comment.id,
                  content: controller.text.trim(),
                );
                
                controller.clear();
                ref.refresh(commentRepliesProvider(comment.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
