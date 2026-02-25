import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_model.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

final adminRoleProvider = FutureProvider<String?>((ref) async {
  // Get current admin role
  return null;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(adminRoleProvider).value != null;
});

final adminMetricsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(adminServiceProvider).getMetrics('');
});

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) {
  return Future.value([]);
});

final adminWithdrawalsProvider = FutureProvider<List<dynamic>>((ref) {
  return Future.value([]);
});

final adminReportsProvider = FutureProvider<List<ReportModel>>((ref) {
  return Future.value([]);
});

final adminLogsProvider = FutureProvider<List<dynamic>>((ref) {
  return Future.value([]);
});

final reserveStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(adminServiceProvider).getReserveStats();
});
