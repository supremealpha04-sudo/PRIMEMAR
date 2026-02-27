import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/chat_provider.dart';
import '../../core/utils/formatter.dart';
import '../../widgets/common/avatar.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {/* New message */},
          ),
        ],
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                'No messages yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              final otherUser = convo['user1_id'] == ref.read(currentUserProvider)?.id
                  ? convo['user2']
                  : convo['user1'];
              final lastMessage = convo['messages']?.first;

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        conversationId: convo['id'],
                        otherUser: otherUser,
                      ),
                    ),
                  );
                },
                leading: UserAvatar(
                  imageUrl: otherUser['profile_image_url'],
                  size: 56.w,
                  isVerified: otherUser['verified_status'] ?? false,
                ),
                title: Row(
                  children: [
                    Text(
                      otherUser['full_name'] ?? otherUser['username'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDark : AppColors.textPrimary,
                      ),
                    ),
                    if (otherUser['verified_status'] ?? false) ...[
                      SizedBox(width: 4.w),
                      Icon(Icons.verified, color: AppColors.verified, size: 16.sp),
                    ],
                  ],
                ),
                subtitle: Text(
                  lastMessage?['content'] ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (lastMessage != null)
                      Text(
                        Formatter.date(DateTime.parse(lastMessage['created_at'])),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (!(lastMessage?['is_read'] ?? true) && 
                        lastMessage?['sender_id'] != ref.read(currentUserProvider)?.id)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
