import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class BankAccountScreen extends ConsumerWidget {
  const BankAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Bank Accounts'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Add new account button
          ListTile(
            onTap: () {/* Add new account */},
            leading: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: AppColors.primary),
            ),
            title: const Text('Add Bank Account'),
            subtitle: const Text('Link a new account for withdrawals'),
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          // List of saved accounts would go here
          Center(
            child: Text(
              'No bank accounts added yet',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
