import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'image_view.dart';

class MediaGrid extends StatelessWidget {
  final List<String> mediaUrls;
  final int maxDisplay;
  final VoidCallback? onTap;
  final VoidCallback? onViewAll;

  const MediaGrid({
    super.key,
    required this.mediaUrls,
    this.maxDisplay = 4,
    this.onTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final displayUrls = mediaUrls.take(maxDisplay).toList();
    final remaining = mediaUrls.length - maxDisplay;

    if (displayUrls.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: displayUrls.length,
      itemBuilder: (context, index) {
        final isLast = index == maxDisplay - 1 && remaining > 0;

        return GestureDetector(
          onTap: isLast ? onViewAll : onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageView(
                imageUrl: displayUrls[index],
                borderRadius: BorderRadius.circular(8.r),
              ),
              if (isLast)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
