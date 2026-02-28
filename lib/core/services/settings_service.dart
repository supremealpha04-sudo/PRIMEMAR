import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/settings_model.dart';

class SettingsService {
  final SupabaseClient _client;

  SettingsService(this._client);

  // Profile Settings
  Future<UserSettings> getUserSettings(String userId) async {
    final response = await _client
        .from('users')
        .select('''
          *,
          notification_settings(*),
          security_settings(*)
        ''')
        .eq('id', userId)
        .single();
    
    return UserSettings.fromJson(response);
  }

  Future<void> updateProfileSettings(String userId, UserSettings settings) async {
    await _client.from('users').update({
      'username': settings.username,
      'full_name': settings.fullName,
      'bio': settings.bio,
      'phone': settings.phone,
      'profile_image_url': settings.profileImageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  // Privacy Settings
  Future<void> updatePrivacySettings(String userId, UserSettings settings) async {
    await _client.from('users').update({
      'is_private': settings.isPrivate,
      'show_online': settings.showOnline,
      'allow_profile_view': settings.allowProfileView,
      'allow_message_request': settings.allowMessageRequest,
      'allow_tag': settings.allowTag,
    }).eq('id', userId);
  }

  // Notification Settings
  Future<void> updateNotificationSettings(String userId, UserSettings settings) async {
    await _client.from('notification_settings').upsert({
      'user_id': userId,
      'followers': settings.notifyFollowers,
      'messages': settings.notifyMessages,
      'likes': settings.notifyLikes,
      'comments': settings.notifyComments,
      'replies': settings.notifyReplies,
      'mentions': settings.notifyMentions,
      'admin': settings.notifyAdmin,
      'payments': settings.notifyPayments,
    });
  }

  // Chat Settings
  Future<void> updateChatSettings(String userId, UserSettings settings) async {
    await _client.from('users').update({
      'messages_locked': settings.messagesLocked,
      'who_can_message': settings.whoCanMessage,
      'read_receipts': settings.readReceipts,
      'typing_indicator': settings.typingIndicator,
    }).eq('id', userId);
  }

  // Security Settings
  Future<void> updateSecuritySettings(String userId, UserSettings settings) async {
    await _client.from('security_settings').upsert({
      'user_id': userId,
      'two_factor_enabled': settings.twoFactorEnabled,
      'biometric_enabled': settings.biometricEnabled,
    });
  }

  // Appearance Settings
  Future<void> updateAppearanceSettings(String userId, UserSettings settings) async {
    await _client.from('users').update({
      'theme': settings.theme,
      'font_size': settings.fontSize,
      'reduce_motion': settings.reduceMotion,
    }).eq('id', userId);
  }

  // Account Management
  Future<void> deactivateAccount(String userId) async {
    await _client.from('users').update({
      'status': 'inactive',
    }).eq('id', userId);
  }

  Future<void> requestAccountDeletion(String userId) async {
    await _client.from('deletion_requests').insert({
      'user_id': userId,
      'status': 'pending',
      'requested_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // Support
  Future<void> submitSupportRequest(String userId, String message, String type) async {
    await _client.from('support_requests').insert({
      'user_id': userId,
      'message': message,
      'type': type,
      'status': 'open',
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
