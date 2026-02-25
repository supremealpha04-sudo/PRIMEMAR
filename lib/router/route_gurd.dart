import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/auth_provider.dart';
import '../features/auth/login_screen.dart';

class RouteGuard extends ConsumerWidget {
  final Widget child;

  const RouteGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return isAuthenticated ? child : const LoginScreen();
  }
}
