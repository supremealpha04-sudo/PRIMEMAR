import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/routes.dart';
import '../core/providers/auth_provider.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/admin/admin_login_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/verify_email_screen.dart';
import '../features/home/home_screen.dart';
import '../features/messages/chat_screen.dart';
import '../features/messages/chat_list_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/post/create_post_screen.dart';
import '../features/post/post_detail_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/followers_screen.dart';
import '../features/profile/following_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/sa/sa_dashboard_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/wallet/wallet_screen.dart';
import 'route_guard.dart';

final routerProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

class AppRouter {
  final Ref _ref;

  AppRouter(this._ref);

  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      // Root
      case Routes.initial:
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      // Auth
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case Routes.verifyEmail:
        final email = args?['email'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: email),
        );

      // Main
      case Routes.home:
        return _guardedRoute(const HomeScreen());

      case Routes.search:
        return _guardedRoute(const SearchScreen());

      // Post
      case Routes.createPost:
        return _guardedRoute(const CreatePostScreen());

      case Routes.postDetail:
        final postId = args?['id'] as String? ?? '';
        return _guardedRoute(PostDetailScreen(postId: postId));

      // Profile
      case Routes.profile:
        final username = args?['username'] as String? ?? '';
        return _guardedRoute(ProfileScreen(username: username));

      case Routes.myProfile:
        return _guardedRoute(const ProfileScreen());

      case Routes.editProfile:
        return _guardedRoute(const EditProfileScreen());

      case Routes.followers:
        final username = args?['username'] as String? ?? '';
        return _guardedRoute(FollowersScreen(username: username));

      case Routes.following:
        final username = args?['username'] as String? ?? '';
        return _guardedRoute(FollowingScreen(username: username));

      // Messages
      case Routes.messages:
      case Routes.chatList:
        return _guardedRoute(const ChatListScreen());

      case Routes.chat:
        final userId = args?['userId'] as String? ?? '';
        return _guardedRoute(ChatScreen(userId: userId));

      // Notifications
      case Routes.notifications:
        return _guardedRoute(const NotificationsScreen());

      // Wallet
      case Routes.wallet:
        return _guardedRoute(const WalletScreen());

      // SA
      case Routes.saDashboard:
        return _guardedRoute(const SaDashboardScreen());

      // Settings
      case Routes.settings:
        return _guardedRoute(const SettingsScreen());

      // Admin
      case Routes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());

      case Routes.adminDashboard:
        return _adminRoute(const AdminDashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  MaterialPageRoute _guardedRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final isAuthenticated = ref.watch(isAuthenticatedProvider);
          return isAuthenticated ? screen : const LoginScreen();
        },
      ),
    );
  }

  MaterialPageRoute _adminRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final isAuthenticated = ref.watch(isAuthenticatedProvider);
          final isAdmin = ref.watch(isAdminProvider);

          if (!isAuthenticated) return const LoginScreen();
          if (!isAdmin) return const AdminLoginScreen();
          return screen;
        },
      ),
    );
  }
}
