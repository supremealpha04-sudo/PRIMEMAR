import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String userId,
    required String content,
    @Default(0) int likesCount,
    @Default(false) bool isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    @Default([]) List<ReplyModel> replies,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}

@freezed
class ReplyModel with _$ReplyModel {
  const factory ReplyModel({
    required String id,
    required String commentId,
    required String userId,
    required String content,
    @Default(0) int likesCount,
    @Default(false) bool isLiked,
    DateTime? createdAt,
    UserModel? user,
  }) = _ReplyModel;

  factory ReplyModel.fromJson(Map<String, dynamic> json) => _$ReplyModelFromJson(json);
}
