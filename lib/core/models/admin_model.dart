import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

@freezed
class AdminModel with _$AdminModel {
  const factory AdminModel({
    required String id,
    required String email,
    required String role,
    @Default(true) bool isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) = _AdminModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) => _$AdminModelFromJson(json);
}

enum AdminRole {
  superAdmin('super_admin', 'Super Admin', 10),
  financeAdmin('finance_admin', 'Finance Admin', 9),
  reserveAdmin('reserve_admin', 'Reserve Admin', 8),
  paymentAdmin('payment_admin', 'Payment Admin', 7),
  userAdmin('user_admin', 'User Admin', 6),
  contentAdmin('content_admin', 'Content Admin', 5),
  chatAdmin('chat_admin', 'Chat Admin', 4),
  marketingAdmin('marketing_admin', 'Marketing Admin', 3),
  analyticsAdmin('analytics_admin', 'Analytics Admin', 2),
  supportAdmin('support_admin', 'Support Admin', 1);

  final String value;
  final String displayName;
  final int level;

  const AdminRole(this.value, this.displayName, this.level);

  static AdminRole fromString(String value) {
    return AdminRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdminRole.supportAdmin,
    );
  }
}
