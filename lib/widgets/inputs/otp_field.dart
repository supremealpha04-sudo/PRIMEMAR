import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class OtpField extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final List<TextEditingController>? controllers;

  const OtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 45.w,
          height: 55.h,
          child: TextField(
            controller: controllers?[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < length - 1) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
              _checkCompleted();
            },
          ),
        );
      }),
    );
  }

  void _checkCompleted() {
    if (controllers != null) {
      final otp = controllers!.map((c) => c.text).join();
      if (otp.length == length && onCompleted != null) {
        onCompleted!(otp);
      }
    }
  }
}
