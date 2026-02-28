import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(notificationServiceProvider).getNotifications(userId);
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return 0;
  return ref.watch(notificationServiceProvider).getUnreadCount(userId);
});
