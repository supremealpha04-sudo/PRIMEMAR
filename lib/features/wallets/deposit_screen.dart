import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/payment_service.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/dialogs/payment_dialog.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _showPaymentOptions() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final method = await showDialog<String>(
      context: context,
      builder: (context) => PaymentDialog(
        amount: amount,
        currency: 'USD',
        description: 'Deposit to wallet',
        onPaymentSelected: (method) => Navigator.pop(context, method),
      ),
    );

    if (method != null) {
      await _processPayment(method, amount);
    }
  }

  Future<void> _processPayment(String method, double amount) async {
    setState(() => _isLoading = true);

    try {
      final paymentService = ref.read(paymentServiceProvider);
      paymentService.setContext(context);

      if (method == 'flutterwave') {
        await paymentService.initiateFlutterwaveDeposit(
          amount: amount,
          currency: 'USD',
          email: ref.read(currentUserProvider)!.email!,
        );
      } else if (method == 'paystack') {
        await paymentService.initiatePaystackDeposit(
          amount: (amount * 100).toInt(), // Convert to kobo/cents
          email: ref.read(currentUserProvider)!.email!,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment initiated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$ ',
                hintText: '0.00',
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Minimum deposit: \$5.00',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Continue',
              isLoading: _isLoading,
              onPressed: _showPaymentOptions,
            ),
          ],
        ),
      ),
    );
  }
}
