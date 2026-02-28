import '../constants/api_constants.dart';
import 'supabase_service.dart';

class AdminService {
  // Verify admin role
  Future<String?> getAdminRole(String email) async {
    final response = await SupabaseService.adminsTable
        .select('role')
        .eq('email', email)
        .maybeSingle();
    
    return response?['role'];
  }
  
  // Check if user has required role
  Future<bool> hasRole(String email, List<String> requiredRoles) async {
    final role = await getAdminRole(email);
    return role != null && requiredRoles.contains(role);
  }
  
  // Super Admin: Create new admin
  Future<void> createAdmin(String email, String role, String creatorEmail) async {
    if (!await hasRole(creatorEmail, ['super_admin'])) {
      throw Exception('Only Super Admin can create admins');
    }
    
    if (role == 'super_admin') {
      throw Exception('Cannot create additional Super Admins');
    }
    
    await SupabaseService.adminsTable.insert({
      'email': email,
      'role': role,
      'is_active': true,
    });
    
    await SupabaseService.adminLogsTable.insert({
      'admin_email': creatorEmail,
      'action': 'create_admin',
      'details': {'new_admin': email, 'role': role},
    });
  }
  
  // User Management Admin
  Future<void> banUser(String userId, String reason, String adminEmail) async {
    if (!await hasRole(adminEmail, ['super_admin', 'user_admin'])) {
      throw Exception('Unauthorized');
    }
    
    await SupabaseService.usersTable
        .update({'status': 'banned'})
        .eq('id', userId);
    
    await SupabaseService.adminLogsTable.insert({
      'admin_email': adminEmail,
      'action': 'ban_user',
      'details': {'user_id': userId, 'reason': reason},
    });
  }
  
  // Finance Admin: Approve withdrawal
  Future<void> approveWithdrawal(String withdrawalId, String adminEmail) async {
    if (!await hasRole(adminEmail, ['super_admin', 'finance_admin'])) {
      throw Exception('Unauthorized');
    }
    
    await SupabaseService.withdrawalsTable
        .update({'status': 'approved', 'approved_by': adminEmail})
        .eq('id', withdrawalId);
  }
  
  // Get admin dashboard metrics
  Future<Map<String, dynamic>> getMetrics(String adminEmail) async {
    if (await getAdminRole(adminEmail) == null) {
      throw Exception('Not an admin');
    }
    
    final usersCount = await SupabaseService.usersTable.select().count();
    final activeUsers = await SupabaseService.usersTable
        .select()
        .eq('status', 'active')
        .count();
    final verifiedCreators = await SupabaseService.usersTable
        .select()
        .eq('verified_status', true)
        .count();
    final totalPosts = await SupabaseService.postsTable.select().count();
    final totalSa = await SupabaseService.transactionsTable
        .select('amount')
        .eq('type', 'earn');
    
    return {
      'total_users': usersCount.count,
      'active_users': activeUsers.count,
      'verified_creators': verifiedCreators.count,
      'total_posts': totalPosts.count,
      'total_sa_distributed': totalSa.fold<double>(0, (sum, t) => sum + (t['amount'] as num)),
    };
  }
}
