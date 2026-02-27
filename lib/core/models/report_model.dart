import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String id,
    required String reporterId,
    required String type, // post, comment, message, user
    required String contentId,
    required String reason,
    String? details,
    @Default('pending') String status,
    String? actionTaken,
    String? resolvedBy,
    DateTime? createdAt,
    DateTime? resolvedAt,
    UserModel? reporter,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);
}
