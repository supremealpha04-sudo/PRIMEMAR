import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/settings_provider.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Security',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildSectionTitle(context, 'Authentication'),
            _buildToggleTile(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Lock',
              subtitle: 'Use fingerprint or face recognition',
              value: settings.biometricEnabled,
              onChanged: (v) => _toggleBiometric(v),
            ),
            _buildActionTile(
              context,
              icon: Icons.pin_outlined,
              title: 'Change Password',
              onTap: () => _showChangePasswordDialog(context),
            ),
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Two-Factor Authentication'),
            _buildToggleTile(
              context,
              icon: Icons.security,
              title: 'Enable 2FA',
              subtitle: 'Add extra security to your account',
              value: settings.twoFactorEnabled,
              onChanged: (v) => _toggle2FA(v),
            ),
            
            SizedBox(height: 24.h),
            _buildSectionTitle(context, 'Active Sessions'),
            _buildSessionsList(context),
            
            SizedBox(height: 24.h),
            _buildDangerZone(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.sp),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context) {
    // Mock sessions data - in production, fetch from security_settings table
    final sessions = [
      {'device': 'iPhone 15 Pro', 'location': 'Lagos, Nigeria', 'current': true},
      {'device': 'Chrome on Windows', 'location': 'Abuja, Nigeria', 'current': false},
    ];

    return Column(
      children: sessions.map((session) => Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.cardDark 
              : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.phone_iphone,
              color: AppColors.textSecondary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        session['device'] as String,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? AppColors.textDark 
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (session['current'] as bool) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Current',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    session['location'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!(session['current'] as bool))
              TextButton(
                onPressed: () => _logoutSession(session['device'] as String),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 13.sp,
                  ),
                ),
              ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 16.h),
          _buildDangerButton(
            context,
            'Logout from all devices',
            Icons.logout,
            () => _logoutAllDevices(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.error, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available')),
        );
        return;
      }
      
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric lock',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (didAuthenticate) {
        await ref.read(settingsProvider.notifier).updateSecurity(biometricEnabled: true);
      }
    } else {
      await ref.read(settingsProvider.notifier).updateSecurity(biometricEnabled: false);
    }
  }

  void _toggle2FA(bool value) {
    if (value) {
      // Navigate to 2FA setup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable 2FA'),
          content: const Text('Two-factor authentication will be enabled for your account.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(settingsProvider.notifier).updateSecurity(twoFactorEnabled: true);
                Navigator.pop(context);
              },
              child: const Text('Enable'),
            ),
          ],
        ),
      );
    } else {
      ref.read(settingsProvider.notifier).updateSecurity(twoFactorEnabled: false);
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  void _logoutSession(String device) {
    // Implement session logout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out from $device')),
    );
  }

  void _logoutAllDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout from all devices?'),
        content: const Text('This will end all active sessions except the current one.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout all
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out from all other devices')),
              );
            },
            child: const Text('Logout All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
              validator: (v) => (v?.length ?? 0) < 8 ? 'Min 8 characters' : null,
            ),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              validator: (v) => v != _newController.text ? 'Passwords don\'t match' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Implement password change via Supabase
              Navigator.pop(context);
            }
          },
          child: const Text('Change'),
        ),
      ],
    );
  }
}
