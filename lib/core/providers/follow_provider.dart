import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/follow_service.dart';

final followServiceProvider = Provider<FollowService>((ref) => FollowService());

final followersProvider = FutureProvider.family<List<UserModel>, String>((ref, username) {
  // Fetch followers
  return Future.value([]);
});

final followingProvider = FutureProvider.family<List<UserModel>, String>((ref, username) {
  // Fetch following
  return Future.value([]);
});
