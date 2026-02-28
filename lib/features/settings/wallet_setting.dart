import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../../core/services/payment_service.dart';

class WalletSettingsScreen extends ConsumerWidget {
  const WalletSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
      ),
      body: walletAsync.when(
        data: (wallet) => ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildBalanceCard(context, wallet),
            SizedBox(height: 24.h),
            _buildActionGrid(context, ref),
            SizedBox(height: 24.h),
            _buildTransactionHistory(context, ref),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Wallet wallet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.token, color: Colors.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'SA Token',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '${wallet.saBalance.toStringAsFixed(2)} SA',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$${wallet.usdBalance.toStringAsFixed(2)} USD',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildBalanceStat(
                  'Total Earned',
                  wallet.totalEarned.toStringAsFixed(2),
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildBalanceStat(
                  'Total Withdrawn',
                  wallet.totalWithdrawn.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context, WidgetRef ref) {
    final actions = [
      {'icon': Icons.add_circle_outline, 'label': 'Deposit', 'color': AppColors.success},
      {'icon': Icons.arrow_circle_up, 'label': 'Withdraw', 'color': AppColors.primary},
      {'icon': Icons.swap_horiz, 'label': 'Convert', 'color': AppColors.warning},
      {'icon': Icons.history, 'label': 'History', 'color': AppColors.textSecondary},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      children: actions.map((action) => GestureDetector(
        onTap: () => _handleAction(context, ref, action['label'] as String),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: (action['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                action['icon'] as IconData,
                color: action['color'] as Color,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              action['label'] as String,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.textDark 
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildTransactionHistory(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {/* Navigate to full history */},
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Mock transactions - in production, fetch from transactions table
        _buildTransactionItem(
          context,
          type: 'earn',
          title: 'Follower Milestone',
          subtitle: '1,000 new followers',
          amount: '+0.5 SA',
          date: '2h ago',
          isPositive: true,
        ),
        _buildTransactionItem(
          context,
          type: 'boost',
          title: 'Post Boost',
          subtitle: 'Boosted post for 48h',
          amount: '-100 SA',
          date: '1d ago',
          isPositive: false,
        ),
        _buildTransactionItem(
          context,
          type: 'withdraw',
          title: 'Withdrawal',
          subtitle: 'To bank account',
          amount: '-50.0 SA',
          date: '3d ago',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required String type,
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required bool isPositive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    IconData icon;
    Color color;
    
    switch (type) {
      case 'earn':
        icon = Icons.trending_up;
        color = AppColors.success;
        break;
      case 'boost':
        icon = Icons.rocket_launch;
        color = AppColors.warning;
        break;
      case 'withdraw':
        icon = Icons.account_balance;
        color = AppColors.error;
        break;
      default:
        icon = Icons.swap_horiz;
        color = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'Deposit':
        _showDepositOptions(context);
        break;
      case 'Withdraw':
        _showWithdrawDialog(context, ref);
        break;
      case 'Convert':
        _showConvertDialog(context);
        break;
      case 'History':
        // Navigate to full history
        break;
    }
  }

  void _showDepositOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Funds',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24.h),
            _buildPaymentOption(
              context,
              'Flutterwave',
              'Pay with card, bank transfer, or mobile money',
              () => _initiateFlutterwavePayment(context),
            ),
            SizedBox(height: 12.h),
            _buildPaymentOption(
              context,
              'Paystack',
              'Secure card and bank payments',
              () => _initiatePaystackPayment(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.payment, color: AppColors.primary),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13.sp)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _initiateFlutterwavePayment(BuildContext context) async {
    // Implement Flutterwave integration
    // Reference: https://pub.dev/packages/flutterwave_standard
    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.initiateFlutterwaveDeposit(
        amount: 100,
        currency: 'USD',
        email: 'user@example.com',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  Future<void> _initiatePaystackPayment(BuildContext context) async {
    // Implement Paystack integration
    // Reference: https://pub.dev/packages/paystack_flutter_sdk
    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.initiatePaystackDeposit(
        amount: 10000, // in kobo
        email: 'user@example.com',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  void _showWithdrawDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Minimum withdrawal: \$5 USD equivalent'),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (SA)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement withdrawal request
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Withdrawal request submitted')),
              );
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showConvertDialog(BuildContext context) {
    // Implement SA to USD/NGN conversion
  }
}
