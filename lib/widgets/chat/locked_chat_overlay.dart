import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/security_service.dart';

class LockedChatOverlay extends StatefulWidget {
  final VoidCallback onUnlock;
  final bool useBiometric;

  const LockedChatOverlay({
    super.key,
    required this.onUnlock,
    this.useBiometric = true,
  });

  @override
  State<LockedChatOverlay> createState() => _LockedChatOverlayState();
}

class _LockedChatOverlayState extends State<LockedChatOverlay> {
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
    
    try {
      final success = await _securityService.authenticateWithBiometrics(
        reason: 'Unlock this chat',
      );
      
      if (success && mounted) {
        widget.onUnlock();
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _verifyPin() async {
    final pin = _pinController.text;
    if (pin.length != 4) return;

    setState(() => _isVerifying = true);

    final success = await _securityService.verifyPin(pin);
    
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
    return Container(
      color: Colors.black.withOpacity(0.95),
      child: Center(
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
                'This chat is locked',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Authenticate to view messages',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 48.h),
              if (widget.useBiometric)
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
              if (widget.useBiometric) SizedBox(height: 16.h),
              Text(
                'Or enter PIN',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    width: 50.w,
                    height: 50.h,
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
