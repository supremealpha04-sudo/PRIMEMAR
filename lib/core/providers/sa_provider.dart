import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sa_reward_model.dart';

final saHistoryProvider = FutureProvider<List<SaRewardModel>>((ref) {
  // Fetch SA earning history
  return Future.value([]);
});
