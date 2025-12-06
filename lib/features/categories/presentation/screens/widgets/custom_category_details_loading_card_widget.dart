import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomCategoryDetailsLoadingCardWidget extends StatelessWidget {
  const CustomCategoryDetailsLoadingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: 160.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160.w,
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 8.h),
            Container(width: 120.w, height: 16.h, color: Colors.grey[300]),
            SizedBox(height: 4.h),
            Container(width: 80.w, height: 12.h, color: Colors.grey[300]),
            SizedBox(height: 4.h),
            Container(width: 60.w, height: 16.h, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
