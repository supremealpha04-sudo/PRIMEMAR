import '../models/wallet_model.dart';
import 'supabase_service.dart';

class WalletService {
  Future<WalletModel> getWallet(String userId) async {
    final response = await SupabaseService.walletsTable
        .select()
        .eq('user_id', userId)
        .single();
    
    return WalletModel.fromJson(response);
  }
  
  Future<void> addFunds(String userId, double amount, String currency) async {
    final column = '${currency.toLowerCase()}_balance';
    await SupabaseService.walletsTable
        .update({column: SupabaseService.client.rpc('increment', params: {'x': amount})})
        .eq('user_id', userId);
  }
  
  Future<bool> deductSa(String userId, double amount) async {
    final wallet = await getWallet(userId);
    if (wallet.saBalance < amount) return false;
    
    await SupabaseService.walletsTable
        .update({
          'sa_balance': SupabaseService.client.rpc('decrement', params: {'x': amount})
        })
        .eq('user_id', userId);
    
    return true;
  }
  
  Future<void> recordTransaction({
    required String userId,
    required String type,
    required double amount,
    String? description,
  }) async {
    await SupabaseService.transactionsTable.insert({
      'user_id': userId,
      'type': type,
      'amount': amount,
      'description': description,
    });
  }
  
  Future<List<Map<String, dynamic>>> getTransactions(String userId, {int limit = 50}) async {
    final response = await SupabaseService.transactionsTable
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return response as List<Map<String, dynamic>>;
  }
}
