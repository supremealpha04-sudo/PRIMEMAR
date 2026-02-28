import '../models/post_model.dart';
import 'supabase_service.dart';

class PostService {
  Future<List<PostModel>> getFeed({int limit = 20, int offset = 0}) async {
    final response = await SupabaseService.postsTable
        .select('*, users!inner(*), likes(count)')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    
    return (response as List).map((json) => PostModel.fromJson(json)).toList();
  }
  
  Future<PostModel> createPost(PostModel post) async {
    final response = await SupabaseService.postsTable
        .insert(post.toJson())
        .select()
        .single();
    
    return PostModel.fromJson(response);
  }
  
  Future<void> deletePost(String postId) async {
    await SupabaseService.postsTable
        .delete()
        .eq('id', postId);
  }
  
  Future<void> incrementViews(String postId) async {
    await SupabaseService.postsTable
        .update({'views_count': SupabaseService.client.rpc('increment', params: {'x': 1})})
        .eq('id', postId);
  }
  
  Future<List<PostModel>> getUserPosts(String userId) async {
    final response = await SupabaseService.postsTable
        .select('*, likes(count)')
        .eq('creator_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => PostModel.fromJson(json)).toList();
  }
  
  Stream<List<PostModel>> subscribeToFeed() {
    return SupabaseService.postsTable
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => data.map((json) => PostModel.fromJson(json)).toList());
  }
}
