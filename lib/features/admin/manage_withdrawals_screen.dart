import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/admin_provider.dart';

class ManageWithdrawalsScreen extends ConsumerWidget {
  const ManageWithdrawalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawalsAsync = ref.watch(adminWithdrawalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Requests'),
      ),
      body: withdrawalsAsync.when(
        data: (withdrawals) => ListView.builder(
          itemCount: withdrawals.length,
          itemBuilder: (context, index) {
            final withdrawal = withdrawals[index];
            return Card(
              margin: EdgeInsets.all(8.w),
              child: ListTile(
                title: Text('${withdrawal.saAmount} SA'),
                subtitle: Text('User: ${withdrawal.userId}'),
                trailing: withdrawal.status == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _approveWithdrawal(ref, withdrawal.id),
                            child: const Text('Approve'),
                          ),
                          TextButton(
                            onPressed: () => _rejectWithdrawal(ref, withdrawal.id),
                            child: const Text('Reject',
                                style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      )
                    : Chip(
                        label: Text(withdrawal.status),
                        backgroundColor: withdrawal.status == 'approved'
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                      ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _approveWithdrawal(WidgetRef ref, String id) async {
    await ref.read(adminServiceProvider).approveWithdrawal(
      id,
      ref.read(currentUserProvider)!.email!,
    );
    ref.invalidate(adminWithdrawalsProvider);
  }

  Future<void> _rejectWithdrawal(WidgetRef ref, String id) async {
    // Implement reject
    ref.invalidate(adminWithdrawalsProvider);
  }
}
