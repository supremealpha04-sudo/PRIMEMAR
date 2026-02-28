import 'supabase_service.dart';

class LikeService {
  Future<bool> toggleLike({
    required String userId,
    String? postId,
    String? commentId,
    String? replyId,
  }) async {
    // Check if already liked
    var query = SupabaseService.likesTable.select()
        .eq('user_id', userId);
    
    if (postId != null) query = query.eq('post_id', postId);
    if (commentId != null) query = query.eq('comment_id', commentId);
    if (replyId != null) query = query.eq('reply_id', replyId);
    
    final existing = await query;
    
    if (existing.isNotEmpty) {
      // Unlike
      await SupabaseService.likesTable
          .delete()
          .eq('id', existing.first['id']);
      return false;
    } else {
      // Like
      await SupabaseService.likesTable.insert({
        'user_id': userId,
        'post_id': postId,
        'comment_id': commentId,
        'reply_id': replyId,
      });
      return true;
    }
  }
  
  Future<int> getLikesCount({String? postId, String? commentId}) async {
    var query = SupabaseService.likesTable.select();
    if (postId != null) query = query.eq('post_id', postId);
    if (commentId != null) query = query.eq('comment_id', commentId);
    
    final response = await query.count();
    return response.count;
  }
  
  Future<bool> hasUserLiked(String userId, String postId) async {
    final response = await SupabaseService.likesTable
        .select()
        .eq('user_id', userId)
        .eq('post_id', postId)
        .count();
    
    return response.count > 0;
  }
}
