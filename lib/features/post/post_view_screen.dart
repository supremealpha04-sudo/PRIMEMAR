import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/post_model.dart';
import '../../widgets/media/video_player.dart';

class PostViewScreen extends ConsumerStatefulWidget {
  final List<PostModel> posts;
  final int initialIndex;

  const PostViewScreen({
    super.key,
    required this.posts,
    required this.initialIndex,
  });

  @override
  ConsumerState<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends ConsumerState<PostViewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.posts.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final post = widget.posts[index];
          return _buildPostItem(post);
        },
      ),
    );
  }

  Widget _buildPostItem(PostModel post) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Media
        if (post.mediaType == 'video' && post.mediaUrl != null)
          VideoPlayerWidget(
            videoUrl: post.mediaUrl!,
            autoPlay: true,
            showControls: false,
          )
        else if (post.mediaUrl != null)
          Image.network(
            post.mediaUrl!,
            fit: BoxFit.contain,
          ),

        // UI Overlay
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {/* Options */},
              ),
            ],
          ),
        ),

        // Bottom Info
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
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  post.content ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
