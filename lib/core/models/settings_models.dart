import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    // Profile
    @Default('') String username,
    @Default('') String fullName,
    @Default('') String bio,
    @Default('') String phone,
    @Default('') String profileImageUrl,
    
    // Privacy
    @Default(false) bool isPrivate,
    @Default(true) bool showOnline,
    @Default(true) bool allowProfileView,
    @Default(true) bool allowMessageRequest,
    @Default(true) bool allowTag,
    
    // Notifications
    @Default(true) bool notifyFollowers,
    @Default(true) bool notifyMessages,
    @Default(true) bool notifyLikes,
    @Default(true) bool notifyComments,
    @Default(true) bool notifyReplies,
    @Default(true) bool notifyMentions,
    @Default(true) bool notifyAdmin,
    @Default(true) bool notifyPayments,
    
    // Chat
    @Default(false) bool messagesLocked,
    @Default('everyone') String whoCanMessage, // everyone, followers, nobody
    @Default(true) bool readReceipts,
    @Default(true) bool typingIndicator,
    
    // Security
    @Default(false) bool twoFactorEnabled,
    @Default(false) bool biometricEnabled,
    
    // Appearance
    @Default('system') String theme, // light, dark, system
    @Default('medium') String fontSize, // small, medium, large
    @Default(false) bool reduceMotion,
    
    // Account
    @Default('active') String accountStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => 
      _$UserSettingsFromJson(json);
}

@freezed
class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    required String userId,
    @Default(false) bool twoFactorEnabled,
    @Default(false) bool biometricEnabled,
    @Default([]) List<UserSession> sessions,
    DateTime? lastPasswordChange,
  }) = _SecuritySettings;

  factory SecuritySettings.fromJson(Map<String, dynamic> json) => 
      _$SecuritySettingsFromJson(json);
}

@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    required String id,
    required String device,
    required String location,
    required DateTime lastActive,
    @Default(false) bool isCurrent,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => 
      _$UserSessionFromJson(json);
}
