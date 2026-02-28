import '../models/comment_model.dart';
import 'supabase_service.dart';

class CommentService {
  Future<List<CommentModel>> getPostComments(String postId) async {
    final response = await SupabaseService.commentsTable
        .select('*, users!inner(*), replies:comment_replies(*, users!inner(*))')
        .eq('post_id', postId)
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => CommentModel.fromJson(json)).toList();
  }
  
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String content,
  }) async {
    final response = await SupabaseService.commentsTable
        .insert({
          'post_id': postId,
          'user_id': userId,
          'content': content,
        })
        .select('*, users!inner(*)')
        .single();
    
    return CommentModel.fromJson(response);
  }
  
  Future<void> deleteComment(String commentId) async {
    await SupabaseService.commentsTable
        .delete()
        .eq('id', commentId);
  }
  
  Future<void> addReply({
    required String commentId,
    required String userId,
    required String content,
  }) async {
    await SupabaseService.client
        .from('comment_replies')
        .insert({
          'comment_id': commentId,
          'user_id': userId,
          'content': content,
        });
  }
  
  Stream<List<CommentModel>> subscribeToComments(String postId) {
    return SupabaseService.commentsTable
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at')
        .map((data) => data.map((json) => CommentModel.fromJson(json)).toList());
  }
}
