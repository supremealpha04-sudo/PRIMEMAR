import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class SaRulesScreen extends StatelessWidget {
  const SaRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('SA Economy Rules'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'How to Earn SA',
              [
                '${ApiConstants.saPerFollowerMilestone} SA per ${ApiConstants.followersMilestoneThreshold} new followers',
                'Daily earning limit: ${ApiConstants.maxDailySaEarning} SA',
                'SA is awarded automatically when you reach follower milestones',
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'SA Distribution',
              [
                '${(ApiConstants.creatorSharePercent * 100).toInt()}% to Creator',
                '${(ApiConstants.platformSharePercent * 100).toInt()}% to Platform',
                '${(ApiConstants.reserveSharePercent * 100).toInt()}% to Reserve',
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Using SA',
              [
                'Boost posts: ${ApiConstants.boostCostSa} SA for ${ApiConstants.boostDurationHours} hours',
                'Withdraw: Convert SA to USD/NGN (min \$${ApiConstants.minWithdrawalUsd})',
                'Subscription: ${ApiConstants.subscriptionCostUsd} USD/month to subscribe to creators',
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Verification',
              [
                'Fee: \$${ApiConstants.verificationFeeUsd}',
                'Requirements: 3000+ followers',
                'Benefits: Verified badge, monetization access',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 20.sp,
                color: AppColors.success,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 15.sp,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
