import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String creatorId,
    String? content,
    String? mediaUrl,
    String? mediaType, // image, video
    @Default(0) int viewsCount,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int repostsCount,
    @Default(false) bool isLiked,
    @Default(false) bool isBookmarked,
    @Default(false) bool boostActive,
    DateTime? boostExpiration,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? creator,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}
