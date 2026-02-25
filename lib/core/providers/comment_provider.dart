import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

final commentServiceProvider = Provider<CommentService>((ref) => CommentService());

final postCommentsProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) {
  return ref.watch(commentServiceProvider).getPostComments(postId);
});

final commentRepliesProvider = FutureProvider.family<List<ReplyModel>, String>((ref, commentId) {
  // Fetch replies for a comment
  return Future.value([]);
});
