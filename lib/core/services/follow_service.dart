import '../models/user_model.dart';
import 'supabase_service.dart';

class FollowService {
  Future<bool> toggleFollow(String followerId, String followingId) async {
    // Check if already following
    final existing = await SupabaseService.followersTable
        .select()
        .eq('follower_id', followerId)
        .eq('following_id', followingId);
    
    if (existing.isNotEmpty) {
      // Unfollow
      await SupabaseService.followersTable
          .delete()
          .eq('id', existing.first['id']);
      
      // Decrement counts
      await _decrementFollowCounts(followerId, followingId);
      return false;
    } else {
      // Follow
      await SupabaseService.followersTable.insert({
        'follower_id': followerId,
        'following_id': followingId,
      });
      
      // Increment counts and check for SA reward
      await _incrementFollowCounts(followerId, followingId);
      return true;
    }
  }
  
  Future<void> _incrementFollowCounts(String followerId, String followingId) async {
    // Update follower count for the one being followed
    await SupabaseService.usersTable
        .update({'followers_count': SupabaseService.client.rpc('increment', params: {'x': 1})})
        .eq('id', followingId);
    
    // Update following count for the follower
    await SupabaseService.usersTable
        .update({'following_count': SupabaseService.client.rpc('increment', params: {'x': 1})})
        .eq('id', followerId);
    
    // Check for SA reward milestone
    await _checkAndRewardSA(followingId);
  }
  
  Future<void> _decrementFollowCounts(String followerId, String followingId) async {
    await SupabaseService.usersTable
        .update({'followers_count': SupabaseService.client.rpc('decrement', params: {'x': 1})})
        .eq('id', followingId);
    
    await SupabaseService.usersTable
        .update({'following_count': SupabaseService.client.rpc('decrement', params: {'x': 1})})
        .eq('id', followerId);
  }
  
  Future<void> _checkAndRewardSA(String userId) async {
    // Get current follower count
    final user = await SupabaseService.usersTable
        .select('followers_count')
        .eq('id', userId)
        .single();
    
    final followersCount = user['followers_count'] as int;
    
    // Check if milestone reached (every 1000)
    if (followersCount % 1000 == 0) {
      final saAmount = 0.5;
      
      // Add SA to wallet using the distribute function
      await SupabaseService.client.rpc('distribute_sa', params: {
        'user_id': userId,
        'amount': saAmount,
        'type': 'follower_milestone',
      });
    }
  }
  
  Future<List<UserModel>> getFollowers(String userId) async {
    final response = await SupabaseService.followersTable
        .select('follower_id, users!follower_id(*)')
        .eq('following_id', userId);
    
    return (response as List).map((json) => UserModel.fromJson(json['users'])).toList();
  }
  
  Future<List<UserModel>> getFollowing(String userId) async {
    final response = await SupabaseService.followersTable
        .select('following_id, users!following_id(*)')
        .eq('follower_id', userId);
    
    return (response as List).map((json) => UserModel.fromJson(json['users'])).toList();
  }
  
  Future<bool> isFollowing(String followerId, String followingId) async {
    final response = await SupabaseService.followersTable
        .select()
        .eq('follower_id', followerId)
        .eq('following_id', followingId)
        .count();
    
    return response.count > 0;
  }
}
