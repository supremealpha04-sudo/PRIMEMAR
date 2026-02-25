import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.buttonText = 'OK',
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      icon: Icon(
        Icons.error_outline,
        color: AppColors.error,
        size: 48.sp,
      ),
      title: Text(title),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDismiss?.call();
          },
          child: Text(
            buttonText!,
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
