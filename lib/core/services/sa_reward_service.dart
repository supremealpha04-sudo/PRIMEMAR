import '../constants/api_constants.dart';
import 'supabase_service.dart';

class SaRewardService {
  // Calculate SA reward for followers milestone
  double calculateFollowerReward(int newFollowers) {
    final milestones = (newFollowers / ApiConstants.followersThreshold).floor();
    return milestones * ApiConstants.saPerFollowers;
  }
  
  // Check and distribute daily limit
  Future<bool> canEarnMoreSa(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final earnedToday = await SupabaseService.transactionsTable
        .select('amount')
        .eq('user_id', userId)
        .eq('type', 'earn')
        .gte('created_at', today)
        .count();
    
    return earnedToday.count < ApiConstants.maxDailySa;
  }
  
  // Distribute SA with 50/30/20 split
  Future<void> distributeSa({
    required String userId,
    required double amount,
    required String type,
  }) async {
    await SupabaseService.client.rpc('distribute_sa', params: {
      'user_id': userId,
      'amount': amount,
      'type': type,
    });
  }
  
  // Process boost payment (100 SA)
  Future<bool> processBoost(String userId, String postId) async {
    final wallet = await SupabaseService.walletsTable
        .select('sa_balance')
        .eq('user_id', userId)
        .single();
    
    if ((wallet['sa_balance'] as num) < ApiConstants.boostCost) {
      return false;
    }
    
    // Distribute boost cost
    await distributeSa(
      userId: userId,
      amount: ApiConstants.boostCost,
      type: 'boost',
    );
    
    // Activate boost
    await SupabaseService.boostsTable.insert({
      'post_id': postId,
      'user_id': userId,
      'cost': ApiConstants.boostCost,
      'expires_at': DateTime.now().add(const Duration(hours: 48)).toIso8601String(),
    });
    
    return true;
  }
}
