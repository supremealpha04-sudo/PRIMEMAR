import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final _auth = SupabaseService.auth;
  
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => currentUser?.id;
  String? get currentUserEmail => currentUser?.email;
  
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
    
    if (response.user != null) {
      // Create user record in users table
      await SupabaseService.usersTable.insert({
        'id': response.user!.id,
        'username': userData['username'],
        'full_name': userData['full_name'],
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Create wallet
      await SupabaseService.walletsTable.insert({
        'user_id': response.user!.id,
        'sa_balance': 0,
        'usd_balance': 0,
        'ngn_balance': 0,
      });
    }
    
    return response;
  }
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }
  
  Future<void> updatePassword(String newPassword) async {
    await _auth.updateUser(UserAttributes(password: newPassword));
  }
  
  Future<void> updateEmail(String newEmail) async {
    await _auth.updateUser(UserAttributes(email: newEmail));
  }
}
