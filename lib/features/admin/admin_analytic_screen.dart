import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/providers/admin_provider.dart';
import '../../widgets/cards/stat_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(adminMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: metricsAsync.when(
        data: (metrics) => GridView.count(
          padding: EdgeInsets.all(16.w),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          children: [
            StatCard(
              title: 'Total Users',
              value: metrics['total_users'].toString(),
              icon: Icons.people,
            ),
            StatCard(
              title: 'Active Users',
              value: metrics['active_users'].toString(),
              icon: Icons.people_outline,
            ),
            StatCard(
              title: 'Verified Creators',
              value: metrics['verified_creators'].toString(),
              icon: Icons.verified,
            ),
            StatCard(
              title: 'Total Posts',
              value: metrics['total_posts'].toString(),
              icon: Icons.article,
            ),
            StatCard(
              title: 'Total SA Distributed',
              value: metrics['total_sa_distributed'].toStringAsFixed(2),
              icon: Icons.token,
              color: AppColors.warning,
            ),
            StatCard(
              title: 'Platform Earnings',
              value: '\$${metrics['platform_earnings']?.toStringAsFixed(2) ?? '0.00'}',
              icon: Icons.attach_money,
              color: AppColors.success,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
