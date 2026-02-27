import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final bool autofocus;

  const SearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: () {
                  controller!.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
