import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomProfileHeaderWidget extends StatelessWidget {
  const CustomProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 130.w,
          height: 130.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondaryColor, width: 1.w),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/png/trend_item_test.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text('John Doe', style: AppTextStyle.styleBlack18Bold),
        SizedBox(height: 5.h),
        Text(
          'john.doe@example.com',
          style: AppTextStyle.styleBlack14W500.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
