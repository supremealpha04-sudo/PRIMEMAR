import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import 'auth_provider.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final conversationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return Future.value([]);
  return ref.watch(chatServiceProvider).getConversations(userId);
});

final messagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, conversationId) {
  return ref.watch(chatServiceProvider).subscribeToMessages(conversationId);
});

final chatLockProvider = FutureProvider.family<bool, String>((ref, chatUserId) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return false;
  return ref.watch(chatServiceProvider).isChatLocked(userId, chatUserId);
});
