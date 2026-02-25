import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/admin_provider.dart';

class ManageAdminsScreen extends ConsumerWidget {
  const ManageAdminsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Admins'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {/* Add new admin */},
          ),
        ],
      ),
      body: Center(
        child: Text('Admin management (Super Admin only)'),
      ),
    );
  }
}
