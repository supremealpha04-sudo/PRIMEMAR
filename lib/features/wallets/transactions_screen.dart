import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/wallet_provider.dart';
import '../../widgets/cards/transaction_card.dart';
import '../../widgets/common/empty.dart';
import '../../widgets/common/loading.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long,
              title: 'No transactions yet',
              subtitle: 'Your transaction history will appear here',
            );
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(
                transaction: transaction,
                onTap: () {/* Show details */},
              );
            },
          );
        },
        loading: () => const LoadingList(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
