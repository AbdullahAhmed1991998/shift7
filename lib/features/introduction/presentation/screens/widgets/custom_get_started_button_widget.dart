import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';

class CustomGetStartedButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomGetStartedButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomAppBottom(
        backgroundColor: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
        height: 50.h,
        width: double.infinity,
        verticalPadding: 12.5.h,
        onTap: onPressed,
        child: Text(
          "startShopping".tr(),
          style: AppTextStyle.styleWhite17W700.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }
}
