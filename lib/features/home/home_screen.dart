import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../messages/chat_list.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../wallet/wallet_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final _screens = [
    const FeedScreen(),
    const SearchScreen(),
    Container(), // Placeholder for create
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Show create post modal
            _showCreatePostModal(context);
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            activeIcon: Icon(AppIcons.homeFilled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(AppIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 24.sp),
            ),
            label: 'Create',
          ),
          const BottomNavigationBarItem(
            icon: Icon(AppIcons.message),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(AppIcons.profile),
            activeIcon: Icon(AppIcons.profileFilled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Create post UI here
                Text('Create Post', style: TextStyle(fontSize: 18.sp)),
              ],
            ),
          );
        },
      ),
    );
  }
}
