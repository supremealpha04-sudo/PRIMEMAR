import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String userId,
    required String type, // earn, spend, deposit, withdraw, boost, subscription
    required double amount,
    String? currency, // SA, USD, NGN
    String? description,
    String? status, // pending, completed, failed
    double? creatorShare,
    double? platformShare,
    double? reserveShare,
    String? paymentMethod,
    String? externalReference,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}
