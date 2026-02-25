import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/admin_provider.dart';

class ManagePostsScreen extends ConsumerWidget {
  const ManagePostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Posts'),
      ),
      body: Center(
        child: Text('Post moderation coming soon'),
      ),
    );
  }
}
