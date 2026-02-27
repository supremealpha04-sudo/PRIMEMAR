import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/post_provider.dart';
import '../../widgets/cards/post_card.dart';
import '../../widgets/common/empty.dart';
import '../../widgets/common/loading.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Icon(Icons.token, color: AppColors.primary, size: 32.sp),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {/* Navigate to notifications */},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(feedProvider.future),
        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return EmptyState(
                icon: Icons.feed_outlined,
                title: 'No posts yet',
                subtitle: 'Follow creators to see their posts here',
                actionLabel: 'Explore',
                onAction: () {/* Navigate to search */},
              );
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onLike: () {/* Toggle like */},
                  onComment: () {/* Show comments */},
                  onShare: () {/* Share post */},
                  onBoost: () {/* Boost post */},
                );
              },
            );
          },
          loading: () => const LoadingList(),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
