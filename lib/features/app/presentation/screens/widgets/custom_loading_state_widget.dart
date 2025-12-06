import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomLoadingStateWidget extends StatelessWidget {
  const CustomLoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.discreteCircle(
            color: AppColors.primaryColor,
            secondRingColor: AppColors.secondaryColor,
            thirdRingColor: AppColors.primaryColor,
            size: 50.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'searchLoading'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
