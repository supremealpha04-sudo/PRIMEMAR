import 'package:freezed_annotation/freezed_annotation.dart';

part 'sa_reward_model.freezed.dart';
part 'sa_reward_model.g.dart';

@freezed
class SaRewardModel with _$SaRewardModel {
  const factory SaRewardModel({
    required String id,
    required String userId,
    required String type, // follower_milestone, post_engagement, etc.
    required double amount,
    required int milestone, // e.g., 1000 followers
    @Default(false) bool isClaimed,
    DateTime? claimedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) = _SaRewardModel;

  factory SaRewardModel.fromJson(Map<String, dynamic> json) => _$SaRewardModelFromJson(json);
}
