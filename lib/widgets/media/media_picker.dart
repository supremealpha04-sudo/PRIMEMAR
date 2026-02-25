import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class MediaPicker extends StatelessWidget {
  final Function(List<File>) onMediaSelected;
  final bool allowMultiple;
  final List<String> allowedTypes; // image, video

  const MediaPicker({
    super.key,
    required this.onMediaSelected,
    this.allowMultiple = false,
    this.allowedTypes = const ['image', 'video'],
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    
    if (allowMultiple) {
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        onMediaSelected(picked.map((x) => File(x.path)).toList());
      }
    } else {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        onMediaSelected([File(picked.path)]);
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    
    if (picked != null) {
      onMediaSelected([File(picked.path)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Add Media',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            if (allowedTypes.contains('image')) ...[
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
            ],
            if (allowedTypes.contains('video'))
              ListTile(
                leading: const Icon(Icons.videocam, color: AppColors.primary),
                title: const Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: AppColors.primary),
              title: const Text('File'),
              onTap: () {
                Navigator.pop(context);
                // File picker implementation
              },
            ),
          ],
        ),
      ),
    );
  }
}
