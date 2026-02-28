import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

final postServiceProvider = Provider<PostService>((ref) => PostService());

final feedProvider = FutureProvider<List<PostModel>>((ref) {
  return ref.watch(postServiceProvider).getFeed();
});

final userPostsProvider = FutureProvider.family<List<PostModel>, String>((ref, userId) {
  return ref.watch(postServiceProvider).getUserPosts(userId);
});

final postDetailProvider = FutureProvider.family<PostModel?, String>((ref, postId) async {
  // Implementation depends on your post fetching logic
  return null;
});
