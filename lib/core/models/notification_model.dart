import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String type, // like, comment, follow, message, mention, etc.
    required String referenceId,
    required String message,
    @Default(false) bool isRead,
    DateTime? createdAt,
    UserModel? actor,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}
