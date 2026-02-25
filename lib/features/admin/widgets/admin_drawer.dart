import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const AdminDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 48.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 16.h),
                Text(
                  'PrimeMar Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _buildNavItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/admin/dashboard',
          ),
          _buildNavItem(
            icon: Icons.people,
            title: 'Users',
            route: '/admin/users',
          ),
          _buildNavItem(
            icon: Icons.article,
            title: 'Posts',
            route: '/admin/posts',
          ),
          _buildNavItem(
            icon: Icons.comment,
            title: 'Comments',
            route: '/admin/comments',
          ),
          _buildNavItem(
            icon: Icons.attach_money,
            title: 'Withdrawals',
            route: '/admin/withdrawals',
          ),
          _buildNavItem(
            icon: Icons.account_balance,
            title: 'Reserve',
            route: '/admin/reserve',
          ),
          _buildNavItem(
            icon: Icons.flag,
            title: 'Reports',
            route: '/admin/reports',
          ),
          _buildNavItem(
            icon: Icons.analytics,
            title: 'Analytics',
            route: '/admin/analytics',
          ),
          _buildNavItem(
            icon: Icons.article,
            title: 'Logs',
            route: '/admin/logs',
          ),
          _buildNavItem(
            icon: Icons.admin_panel_settings,
            title: 'Admins',
            route: '/admin/admins',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {/* Logout */},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
      ),
      selected: isSelected,
      onTap: () => onNavigate(route),
    );
  }
}
