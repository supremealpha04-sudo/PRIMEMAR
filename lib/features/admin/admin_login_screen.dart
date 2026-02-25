import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/admin_provider.dart';
import '../../widgets/buttons/primary_button.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final isAdmin = await ref.read(adminServiceProvider).getAdminRole(
        _emailController.text.trim(),
      );

      if (isAdmin != null) {
        // Navigate to admin dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/admin/dashboard');
        }
      } else {
        throw Exception('Not authorized as admin');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 80.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 32.h),
              Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Admin Email',
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 32.h),
              PrimaryButton(
                text: 'Login',
                isLoading: _isLoading,
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
