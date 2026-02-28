import '../constants/api_constants.dart';
import 'supabase_service.dart';

class ReserveService {
  // Only accessible by super_admin and reserve_admin
  Future<Map<String, dynamic>> getReserveStats() async {
    final reserve = await SupabaseService.reserveTable
        .select()
        .single();
    
    final weeklyChange = await _getReserveChange(days: 7);
    final monthlyChange = await _getReserveChange(days: 30);
    
    return {
      'total_sa_reserved': reserve['total_sa_reserved'],
      'weekly_change': weeklyChange,
      'monthly_change': monthlyChange,
      'updated_at': reserve['updated_at'],
    };
  }
  
  Future<double> _getReserveChange({required int days}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    
    final result = await SupabaseService.transactionsTable
        .select('reserve_share')
        .gte('created_at', startDate.toIso8601String())
        .eq('type', 'earn');
    
    return result.fold<double>(0, (sum, t) => sum + (t['reserve_share'] as num));
  }
  
  // Admin only: Release reserve SA for promotions/events
  Future<void> releaseReserve(double amount, String reason, String adminEmail) async {
    // Verify admin role
    final admin = await SupabaseService.adminsTable
        .select()
        .eq('email', adminEmail)
        .single();
    
    if (!['super_admin', 'reserve_admin'].contains(admin['role'])) {
      throw Exception('Unauthorized');
    }
    
    // Update reserve
    await SupabaseService.reserveTable
        .update({
          'total_sa_reserved': SupabaseService.client.rpc('decrement', params: {'x': amount})
        })
        .eq('id', 1); // Single row for reserve
    
    // Log action
    await SupabaseService.adminLogsTable.insert({
      'admin_email': adminEmail,
      'action': 'release_reserve',
      'details': {'amount': amount, 'reason': reason},
    });
  }
}
