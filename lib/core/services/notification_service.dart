import '../models/notification_model.dart';
import 'supabase_service.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications(String userId, {int limit = 50}) async {
    final response = await SupabaseService.notificationsTable
        .select('*, actor:users!reference_id(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return (response as List).map((json) => NotificationModel.fromJson(json)).toList();
  }
  
  Future<void> createNotification({
    required String userId,
    required String type,
    required String referenceId,
    required String message,
  }) async {
    await SupabaseService.notificationsTable.insert({
      'user_id': userId,
      'type': type,
      'reference_id': referenceId,
      'message': message,
      'is_read': false,
    });
  }
  
  Future<void> markAsRead(String notificationId) async {
    await SupabaseService.notificationsTable
        .update({'is_read': true})
        .eq('id', notificationId);
  }
  
  Future<void> markAllAsRead(String userId) async {
    await SupabaseService.notificationsTable
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }
  
  Future<int> getUnreadCount(String userId) async {
    final response = await SupabaseService.notificationsTable
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .count();
    
    return response.count;
  }
  
  Stream<List<NotificationModel>> subscribeToNotifications(String userId) {
    return SupabaseService.notificationsTable
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((data) => data.map((json) => NotificationModel.fromJson(json)).toList());
  }
}
