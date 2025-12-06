import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomPermissionDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String positive;
  final String negative;
  final IconData icon;

  const CustomPermissionDialogWidget({
    super.key,
    required this.title,
    required this.message,
    required this.positive,
    required this.negative,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        titlePadding: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: AppTextStyle.styleBlack16Bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyle.styleBlack14W500,
          textAlign: TextAlign.center,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SizedBox(
              height: 42.h,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                child: Text(
                  negative,
                  style: AppTextStyle.styleBlack14W500.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            height: 42.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
              ),
              child: Text(
                positive,
                style: AppTextStyle.styleBlack14W500.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
