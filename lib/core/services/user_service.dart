import '../models/user_model.dart';
import 'supabase_service.dart';

class UserService {
  Future<UserModel?> getUser(String userId) async {
    final response = await SupabaseService.usersTable
        .select('*, wallets(*)')
        .eq('id', userId)
        .single();
    
    return UserModel.fromJson(response);
  }
  
  Future<UserModel?> getUserByUsername(String username) async {
    final response = await SupabaseService.usersTable
        .select('*, wallets(*)')
        .eq('username', username)
        .single();
    
    return UserModel.fromJson(response);
  }
  
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await SupabaseService.usersTable
        .update(data)
        .eq('id', userId);
  }
  
  Future<List<UserModel>> searchUsers(String query) async {
    final response = await SupabaseService.usersTable
        .select()
        .ilike('username', '%$query%')
        .limit(20);
    
    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }
  
  Future<bool> isUsernameAvailable(String username) async {
    final response = await SupabaseService.usersTable
        .select()
        .eq('username', username)
        .count();
    
    return response.count == 0;
  }
}
