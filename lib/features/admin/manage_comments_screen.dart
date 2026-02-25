import 'package:flutter/material.dart';

class ManageCommentsScreen extends StatelessWidget {
  const ManageCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Comments'),
      ),
      body: Center(
        child: Text('Comment moderation coming soon'),
      ),
    );
  }
}
