import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/security_service.dart';

class UnlockChatScreen extends ConsumerStatefulWidget {
  final String chatUserId;
  final VoidCallback onUnlock;

  const UnlockChatScreen({
    super.key,
    required this.chatUserId,
    required this.onUnlock,
  });

  @override
  ConsumerState<UnlockChatScreen> createState() => _UnlockChatScreenState();
}

class _UnlockChatScreenState extends ConsumerState<UnlockChatScreen> {
  final _securityService = SecurityService();
  final _pinController = TextEditingController();
  bool _isVerifying = false;
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() => _isVerifying = true);

    final success = await _securityService.authenticateWithBiometrics(
      reason: 'Unlock this chat',
    );

    if (success && mounted) {
      widget.onUnlock();
    } else {
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _verifyPin() async {
    if (_pinController.text.length != 4) return;

    setState(() => _isVerifying = true);

    final success = await _securityService.verifyPin(_pinController.text);

    if (mounted) {
      if (success) {
        widget.onUnlock();
      } else {
        setState(() {
          _error = 'Incorrect PIN';
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 24.h),
              Text(
                'Chat Locked',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Authenticate to continue',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 48.h),

              // Biometric Button
              ElevatedButton.icon(
                onPressed: _isVerifying ? null : _authenticateWithBiometric,
                icon: _isVerifying
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.fingerprint),
                label: Text(_isVerifying ? 'Verifying...' : 'Use Biometric'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                'Or enter PIN',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 16.h),

              // PIN Input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    width: 50.w,
                    child: TextField(
                      controller: index == 0 ? _pinController : null,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        errorText: index == 0 ? _error : null,
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (index == 3 && value.length == 1) {
                          _verifyPin();
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
