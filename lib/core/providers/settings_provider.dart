import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/settings_model.dart';
import '../services/settings_service.dart';

// Services
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(Supabase.instance.client);
});

// State Notifier
class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  final SettingsService _service;
  String? _userId;

  SettingsNotifier(this._service) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _userId = user.id;
        await loadSettings();
      } else {
        state = AsyncValue.error('Not authenticated', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadSettings() async {
    if (_userId == null) return;
    
    state = const AsyncValue.loading();
    try {
      final settings = await _service.getUserSettings(_userId!);
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? bio,
    String? phone,
    String? profileImageUrl,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        username: username ?? current.username,
        fullName: fullName ?? current.fullName,
        bio: bio ?? current.bio,
        phone: phone ?? current.phone,
        profileImageUrl: profileImageUrl ?? current.profileImageUrl,
        updatedAt: DateTime.now(),
      );
      
      await _service.updateProfileSettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePrivacy({
    bool? isPrivate,
    bool? showOnline,
    bool? allowProfileView,
    bool? allowMessageRequest,
    bool? allowTag,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        isPrivate: isPrivate ?? current.isPrivate,
        showOnline: showOnline ?? current.showOnline,
        allowProfileView: allowProfileView ?? current.allowProfileView,
        allowMessageRequest: allowMessageRequest ?? current.allowMessageRequest,
        allowTag: allowTag ?? current.allowTag,
      );
      
      await _service.updatePrivacySettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNotifications({
    bool? notifyFollowers,
    bool? notifyMessages,
    bool? notifyLikes,
    bool? notifyComments,
    bool? notifyReplies,
    bool? notifyMentions,
    bool? notifyAdmin,
    bool? notifyPayments,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        notifyFollowers: notifyFollowers ?? current.notifyFollowers,
        notifyMessages: notifyMessages ?? current.notifyMessages,
        notifyLikes: notifyLikes ?? current.notifyLikes,
        notifyComments: notifyComments ?? current.notifyComments,
        notifyReplies: notifyReplies ?? current.notifyReplies,
        notifyMentions: notifyMentions ?? current.notifyMentions,
        notifyAdmin: notifyAdmin ?? current.notifyAdmin,
        notifyPayments: notifyPayments ?? current.notifyPayments,
      );
      
      await _service.updateNotificationSettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateChatSettings({
    bool? messagesLocked,
    String? whoCanMessage,
    bool? readReceipts,
    bool? typingIndicator,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        messagesLocked: messagesLocked ?? current.messagesLocked,
        whoCanMessage: whoCanMessage ?? current.whoCanMessage,
        readReceipts: readReceipts ?? current.readReceipts,
        typingIndicator: typingIndicator ?? current.typingIndicator,
      );
      
      await _service.updateChatSettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSecurity({
    bool? twoFactorEnabled,
    bool? biometricEnabled,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        twoFactorEnabled: twoFactorEnabled ?? current.twoFactorEnabled,
        biometricEnabled: biometricEnabled ?? current.biometricEnabled,
      );
      
      await _service.updateSecuritySettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAppearance({
    String? theme,
    String? fontSize,
    bool? reduceMotion,
  }) async {
    if (_userId == null) return;
    
    try {
      final current = state.value!;
      final updated = current.copyWith(
        theme: theme ?? current.theme,
        fontSize: fontSize ?? current.fontSize,
        reduceMotion: reduceMotion ?? current.reduceMotion,
      );
      
      await _service.updateAppearanceSettings(_userId!, updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deactivateAccount() async {
    if (_userId == null) return;
    await _service.deactivateAccount(_userId!);
  }

  Future<void> deleteAccount() async {
    if (_userId == null) return;
    await _service.requestAccountDeletion(_userId!);
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AsyncValue.loading();
  }
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
  return SettingsNotifier(ref.watch(settingsServiceProvider));
});

// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void setTheme(String theme) {
    switch (theme) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }
}
