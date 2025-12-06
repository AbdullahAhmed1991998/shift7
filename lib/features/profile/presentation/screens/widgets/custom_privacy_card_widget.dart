import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomPrivacyCardWidget extends StatelessWidget {
  const CustomPrivacyCardWidget({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withAlpha(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(24),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyle.stylePrimary16Bold.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.stylePrimary16Bold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                textAlign: TextAlign.start,
                style: AppTextStyle.styleBlack14W500.copyWith(
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
