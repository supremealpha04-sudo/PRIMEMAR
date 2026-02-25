import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/follow_provider.dart';
import '../../widgets/cards/user_card.dart';
import '../../widgets/common/empty.dart';
import '../../widgets/common/loading.dart';

class FollowingScreen extends ConsumerWidget {
  final String username;

  const FollowingScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(followingProvider(username));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: followingAsync.when(
        data: (following) {
          if (following.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'Not following anyone',
              subtitle: 'Accounts this user follows will appear here',
            );
          }
          return ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              final user = following[index];
              return UserCard(
                user: user,
                onTap: () {/* Navigate to profile */},
                onFollow: () {/* Toggle follow */},
              );
            },
          );
        },
        loading: () => const LoadingList(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
