import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomDotsIndicatorWidget extends StatelessWidget {
  final int count;
  final int currentIndex;

  const CustomDotsIndicatorWidget({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: index == currentIndex ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            shape: index == currentIndex ? BoxShape.rectangle : BoxShape.circle,
            borderRadius:
                index == currentIndex ? BorderRadius.circular(20.r) : null,
            color:
                index == currentIndex ? AppColors.secondaryColor : Colors.grey,
          ),
        );
      }),
    );
  }
}
