import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    String? email,
    String? fullName,
    String? bio,
    String? phone,
    String? profileImageUrl,
    String? coverImageUrl,
    @Default(false) bool isVerified,
    @Default(false) bool isPrivate,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int postsCount,
    @Default('active') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
    WalletModel? wallet,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    required String userId,
    @Default(0.0) double saBalance,
    @Default(0.0) double usdBalance,
    @Default(0.0) double ngnBalance,
    @Default(0.0) double totalEarned,
    @Default(0.0) double totalWithdrawn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);
}
