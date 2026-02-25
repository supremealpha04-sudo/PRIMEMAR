import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/post_provider.dart';
import '../../widgets/media/video_player.dart';

class VideoFeedScreen extends ConsumerWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: postsAsync.when(
        data: (posts) {
          final videoPosts = posts.where((p) => p.mediaType == 'video').toList();

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videoPosts.length,
            itemBuilder: (context, index) {
              final post = videoPosts[index];

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Video Player
                  if (post.mediaUrl != null)
                    VideoPlayerWidget(
                      videoUrl: post.mediaUrl!,
                      autoPlay: true,
                      showControls: false,
                    ),

                  // Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${post.creator?.username ?? 'unknown'}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            post.content ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Side Actions
                  Positioned(
                    right: 16.w,
                    bottom: 100.h,
                    child: Column(
                      children: [
                        _buildActionButton(
                          icon: post.isLiked ? Icons.favorite : Icons.favorite_outline,
                          count: post.likesCount,
                          color: post.isLiked ? AppColors.error : Colors.white,
                          onTap: () {/* Like */},
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          icon: Icons.comment,
                          count: post.commentsCount,
                          onTap: () {/* Comments */},
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          icon: Icons.share,
                          onTap: () {/* Share */},
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color ?? Colors.white, size: 32.sp),
          if (count != null) ...[
            SizedBox(height: 4.h),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
