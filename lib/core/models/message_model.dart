import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaUrl,
    @Default('text') String messageType, // text, image, video, file
    @Default(false) bool isRead,
    @Default(false) bool isLocked,
    DateTime? createdAt,
    UserModel? sender,
    UserModel? receiver,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required String user1Id,
    required String user2Id,
    String? lastMessageContent,
    DateTime? lastMessageAt,
    @Default(false) bool isLocked,
    DateTime? createdAt,
    UserModel? user1,
    UserModel? user2,
    @Default(0) int unreadCount,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);
}
