import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomDotsIndicatorWidget extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const CustomDotsIndicatorWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  currentPage == index
                      ? AppColors.secondaryColor
                      : Colors.grey.withAlpha(128),
            ),
          ),
        ),
      ),
    );
  }
}
