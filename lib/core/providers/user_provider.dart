import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return null;
  return ref.watch(userServiceProvider).getUser(userId);
});

final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) {
  return ref.watch(userServiceProvider).getUser(userId);
});
