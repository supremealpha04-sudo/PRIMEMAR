import '../models/message_model.dart';
import 'supabase_service.dart';

class ChatService {
  Future<String> getOrCreateConversation(String user1Id, String user2Id) async {
    // Check if conversation exists
    final existing = await SupabaseService.conversationsTable
        .select()
        .or('and(user1_id.eq.$user1Id,user2_id.eq.$user2Id),and(user1_id.eq.$user2Id,user2_id.eq.$user1Id)')
        .maybeSingle();
    
    if (existing != null) {
      return existing['id'] as String;
    }
    
    // Create new conversation
    final response = await SupabaseService.conversationsTable
        .insert({
          'user1_id': user1Id,
          'user2_id': user2Id,
        })
        .select()
        .single();
    
    return response['id'] as String;
  }
  
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaUrl,
    String messageType = 'text',
  }) async {
    final response = await SupabaseService.messagesTable
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'receiver_id': receiverId,
          'content': content,
          'media_url': mediaUrl,
          'message_type': messageType,
          'is_read': false,
        })
        .select('*, sender:users!sender_id(*), receiver:users!receiver_id(*)')
        .single();
    
    // Update conversation last_message_at
    await SupabaseService.conversationsTable
        .update({'last_message_at': DateTime.now().toIso8601String()})
        .eq('id', conversationId);
    
    return MessageModel.fromJson(response);
  }
  
  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50}) async {
    final response = await SupabaseService.messagesTable
        .select('*, sender:users!sender_id(*), receiver:users!receiver_id(*)')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return (response as List).map((json) => MessageModel.fromJson(json)).toList();
  }
  
  Future<void> markAsRead(String messageId) async {
    await SupabaseService.messagesTable
        .update({'is_read': true})
        .eq('id', messageId);
  }
  
  Future<void> markConversationAsRead(String conversationId, String userId) async {
    await SupabaseService.messagesTable
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .eq('receiver_id', userId)
        .eq('is_read', false);
  }
  
  Stream<List<MessageModel>> subscribeToMessages(String conversationId) {
    return SupabaseService.messagesTable
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
  }
  
  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    final response = await SupabaseService.conversationsTable
        .select('''
          *,
          user1:users!user1_id(*),
          user2:users!user2_id(*),
          messages:messages(content, created_at, is_read, sender_id)
        ''')
        .or('user1_id.eq.$userId,user2_id.eq.$userId')
        .order('last_message_at', ascending: false);
    
    return response as List<Map<String, dynamic>>;
  }
  
  // Chat Lock
  Future<void> lockChat(String userId, String chatUserId) async {
    await SupabaseService.client.from('chat_locks').upsert({
      'user_id': userId,
      'chat_user_id': chatUserId,
      'is_locked': true,
    });
  }
  
  Future<void> unlockChat(String userId, String chatUserId) async {
    await SupabaseService.client.from('chat_locks').upsert({
      'user_id': userId,
      'chat_user_id': chatUserId,
      'is_locked': false,
    });
  }
  
  Future<bool> isChatLocked(String userId, String chatUserId) async {
    final response = await SupabaseService.client
        .from('chat_locks')
        .select()
        .eq('user_id', userId)
        .eq('chat_user_id', chatUserId)
        .maybeSingle();
    
    return response?['is_locked'] ?? false;
  }
}
