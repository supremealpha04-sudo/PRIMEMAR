import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_model.dart';
import '../services/wallet_service.dart';
import 'auth_provider.dart';

final walletServiceProvider = Provider<WalletService>((ref) => WalletService());

final walletProvider = FutureProvider<WalletModel>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) throw Exception('Not authenticated');
  return ref.watch(walletServiceProvider).getWallet(userId);
});

final transactionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(walletServiceProvider).getTransactions(userId);
});
