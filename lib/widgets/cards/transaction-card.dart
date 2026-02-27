import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/transaction_model.dart';
import '../../core/utils/formatter.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = _isPositiveTransaction(transaction.type);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: _getIconColor(transaction.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          _getIcon(transaction.type),
          color: _getIconColor(transaction.type),
          size: 24.sp,
        ),
      ),
      title: Text(
        _getTitle(transaction.type),
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textDark : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        Formatter.date(transaction.createdAt ?? DateTime.now()),
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isPositive ? '+' : '-'}${Formatter.sa(transaction.amount)}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
          if (transaction.status != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getStatusColor(transaction.status!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                transaction.status!,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: _getStatusColor(transaction.status!),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isPositiveTransaction(String type) {
    return ['earn', 'deposit', 'refund'].contains(type);
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'earn':
        return Icons.trending_up;
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdraw':
        return Icons.arrow_upward;
      case 'boost':
        return Icons.rocket_launch;
      case 'subscription':
        return Icons.star;
      case 'verification':
        return Icons.verified;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'earn':
        return AppColors.success;
      case 'deposit':
        return AppColors.primary;
      case 'withdraw':
        return AppColors.error;
      case 'boost':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getTitle(String type) {
    return type.replaceAll('_', ' ').toTitleCase();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
