import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class DataStorageScreen extends ConsumerWidget {
  const DataStorageScreen({super.key});

  Future<void> _clearCache(BuildContext context) async {
    // Clear image cache
    // Clear local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared')),
    );
  }

  Future<void> _downloadData(BuildContext context) async {
    // Export user data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export requested')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Data & Storage'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up space by clearing temporary files'),
            onTap: () => _clearCache(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download My Data'),
            subtitle: const Text('Get a copy of your personal data'),
            onTap: () => _downloadData(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Storage Usage'),
            subtitle: const Text('Media: 0 MB • Cache: 0 MB'),
          ),
        ],
      ),
    );
  }
}
