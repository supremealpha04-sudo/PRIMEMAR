import 'supabase_service.dart';

class ReportService {
  Future<void> reportContent({
    required String reporterId,
    required String type, // post, comment, message, user
    required String contentId,
    required String reason,
    String? details,
  }) async {
    await SupabaseService.client.from('reports').insert({
      'reporter_id': reporterId,
      'type': type,
      'content_id': contentId,
      'reason': reason,
      'details': details,
      'status': 'pending',
    });
  }
  
  // Admin only: Get reports
  Future<List<Map<String, dynamic>>> getReports(String adminEmail, {String? status}) async {
    // Verify admin role
    final admin = await SupabaseService.adminsTable
        .select()
        .eq('email', adminEmail)
        .single();
    
    if (!['super_admin', 'content_admin', 'chat_admin'].contains(admin['role'])) {
      throw Exception('Unauthorized');
    }
    
    var query = SupabaseService.client.from('reports').select();
    if (status != null) {
      query = query.eq('status', status);
    }
    
    return await query.order('created_at', ascending: false);
  }
  
  // Admin only: Resolve report
  Future<void> resolveReport(String reportId, String action, String adminEmail) async {
    await SupabaseService.client.from('reports')
        .update({
          'status': 'resolved',
          'action_taken': action,
          'resolved_by': adminEmail,
          'resolved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', reportId);
  }
}
