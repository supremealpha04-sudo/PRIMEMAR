import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class PaymentDialog extends StatefulWidget {
  final double amount;
  final String currency;
  final String description;
  final Function(String method) onPaymentSelected;

  const PaymentDialog({
    super.key,
    required this.amount,
    required this.currency,
    required this.description,
    required this.onPaymentSelected,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.description,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          _buildPaymentOption(
            'flutterwave',
            'Flutterwave',
            'Card, Bank Transfer, Mobile Money',
            Icons.credit_card,
          ),
          SizedBox(height: 12.h),
          _buildPaymentOption(
            'paystack',
            'Paystack',
            'Card, Bank, USSD',
            Icons.account_balance,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedMethod != null
              ? () {
                  Navigator.pop(context);
                  widget.onPaymentSelected(_selectedMethod!);
                }
              : null,
          child: const Text('Continue'),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
