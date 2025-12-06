import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomCardContainer extends StatelessWidget {
  final Widget child;
  const CustomCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.greyColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(32),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
