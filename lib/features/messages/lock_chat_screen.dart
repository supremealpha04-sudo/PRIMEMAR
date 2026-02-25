import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/security_service.dart';

class LockChatScreen extends ConsumerStatefulWidget {
  final String chatUserId;

  const LockChatScreen({
    super.key,
    required this.chatUserId,
  });

  @override
  ConsumerState<LockChatScreen> createState() => _LockChatScreenState();
}

class _LockChatScreenState extends ConsumerState<LockChatScreen> {
  final _securityService = SecurityService();
  bool _useBiometric = true;
  bool _usePin = false;
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _setupLock() async {
    if (_usePin) {
      if (_pinController.text.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN must be 4 digits')),
        );
        return;
      }
      if (_pinController.text != _confirmPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PINs do not match')),
        );
        return;
      }
      await _securityService.setPin(_pinController.text);
    }

    // Save chat lock settings
    await _securityService.setChatLockEnabled(true);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Lock Chat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how to lock this chat',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),

            // Biometric Option
            CheckboxListTile(
              title: const Text('Use Biometric'),
              subtitle: const Text('Fingerprint or Face ID'),
              value: _useBiometric,
              onChanged: (value) => setState(() => _useBiometric = value!),
              secondary: const Icon(Icons.fingerprint),
            ),

            // PIN Option
            CheckboxListTile(
              title: const Text('Use PIN'),
              subtitle: const Text('4-digit PIN code'),
              value: _usePin,
              onChanged: (value) => setState(() => _usePin = value!),
              secondary: const Icon(Icons.pin_outlined),
            ),

            if (_usePin) ...[
              SizedBox(height: 24.h),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter 4-digit PIN',
                  counterText: '',
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  counterText: '',
                ),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _setupLock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Lock Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
