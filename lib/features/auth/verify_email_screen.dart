import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/otp_field.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool _isLoading = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() => _isLoading = true);

    try {
      // Verify OTP logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (mounted) {
        // Navigate to home or next screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() => _resendTimer = 60);
    _startResendTimer();

    try {
      await ref.read(authServiceProvider).resendVerificationEmail(widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content Text('Verification code resent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textDark : AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We\'ve sent a 6-digit verification code to ${widget.email}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 48.h),
              OtpField(
                length: 6,
                controllers: _otpControllers,
                onCompleted: _verifyOtp,
              ),
              SizedBox(height: 32.h),
              PrimaryButton(
                text: 'Verify',
                isLoading: _isLoading,
                onPressed: () {
                  final otp = _otpControllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    _verifyOtp(otp);
                  }
                },
              ),
              SizedBox(height: 24.h),
              Center(
                child: _resendTimer > 0
                    ? Text(
                        'Resend code in $_resendTimer seconds',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : TextButton(
                        onPressed: _resendCode,
                        child: const Text('Resend Code'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
