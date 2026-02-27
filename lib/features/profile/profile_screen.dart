import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/utils/formatter.dart';
import '../../widgets/common/avatar.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: userAsync.when(
        data: (user) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.primary,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset(0, -40.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          UserAvatar(
                            imageUrl: user?.profileImageUrl,
                            size: 80,
                            isVerified: user?.isVerified ?? false,
                          ),
                          ElevatedButton(
                            onPressed: () {/* Edit profile */},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                              foregroundColor: isDark ? AppColors.textDark : AppColors.textPrimary,
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Text(
                            user?.fullName ?? 'User',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textDark : AppColors.textPrimary,
                            ),
                          ),
                          if (user?.isVerified ?? false) ...[
                            SizedBox(width: 8.w),
                            Icon(Icons.verified, color: AppColors.verified, size: 20.sp),
                          ],
                        ],
                      ),
                      Text(
                        '@${user?.username ?? 'username'}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (user?.bio != null) ...[
                        SizedBox(height: 12.h),
                        Text(
                          user!.bio!,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: isDark ? AppColors.textDark : AppColors.textPrimary,
                          ),
                        ),
                      ],
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          _buildStat('Following', user?.followingCount ?? 0),
                          SizedBox(width: 24.w),
                          _buildStat('Followers', user?.followersCount ?? 0),
                          SizedBox(width: 24.w),
                          _buildStat('Posts', user?.postsCount ?? 0),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return GestureDetector(
      onTap: () {/* Navigate to list */},
      child: Row(
        children: [
          Text(
            Formatter.number(count),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
