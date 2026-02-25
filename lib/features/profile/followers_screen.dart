import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/follow_provider.dart';
import '../../widgets/cards/user_card.dart';
import '../../widgets/common/empty.dart';
import '../../widgets/common/loading.dart';

class FollowersScreen extends ConsumerWidget {
  final String username;

  const FollowersScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersAsync = ref.watch(followersProvider(username));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: followersAsync.when(
        data: (followers) {
          if (followers.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'No followers yet',
              subtitle: 'When people follow this account, they\'ll appear here',
            );
          }
          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final user = followers[index];
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
