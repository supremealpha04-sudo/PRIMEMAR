import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/admin_provider.dart';
import '../../widgets/common/loading.dart';

class ManageUsersScreen extends ConsumerWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {/* Search users */},
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? Text(user.username[0].toUpperCase())
                    : null,
              ),
              title: Text(user.username),
              subtitle: Text(user.email ?? ''),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'ban':
                      await ref.read(adminServiceProvider).banUser(
                        user.id,
                        'Violation of terms',
                        ref.read(currentUserProvider)!.email!,
                      );
                      break;
                    case 'verify':
                      // Verify user
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Text('View Profile'),
                  ),
                  const PopupMenuItem(
                    value: 'verify',
                    child: Text('Verify Account'),
                  ),
                  const PopupMenuItem(
                    value: 'ban',
                    child: Text('Ban User'),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const LoadingList(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
