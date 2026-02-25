import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/admin_provider.dart';
import '../../widgets/cards/stat_card.dart';

class ManageReserveScreen extends ConsumerWidget {
  const ManageReserveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveStatsAsync = ref.watch(reserveStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Management'),
      ),
      body: reserveStatsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              StatCard(
                title: 'Total SA Reserved',
                value: stats['total_sa_reserved'].toStringAsFixed(2),
                icon: Icons.account_balance,
                color: AppColors.warning,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Weekly Change',
                      value: '+${stats['weekly_change'].toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: StatCard(
                      title: 'Monthly Change',
                      value: '+${stats['monthly_change'].toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {/* Release reserve */},
                icon: const Icon(Icons.upload),
                label: const Text('Release Reserve SA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
