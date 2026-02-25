import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/post_model.dart';
import '../../core/providers/post_provider.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/text_field.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const EditPostScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (_contentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(postServiceProvider).updatePost(
        widget.post.id,
        {'content': _contentController.text.trim()},
      );

      if (mounted) {
        Helpers.showSnackBar(context, 'Post updated');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, e.toString(), isError: true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updatePost,
            child: _isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            AppTextField(
              controller: _contentController,
              maxLines: 10,
              hint: 'What\'s on your mind?',
            ),
            if (widget.post.mediaUrl != null) ...[
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  widget.post.mediaUrl!,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
