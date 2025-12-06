import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCheckoutButton extends StatelessWidget {
  final double totalPrice;
  const CustomCheckoutButton({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return CustomAppBottom(
      height: 50.h,
      verticalPadding: 12.5.h,
      horizontalPadding: 40.w,
      backgroundColor: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutesKeys.checkout,
          arguments: {'totalPrice': totalPrice},
        );
      },
      child: Text(
        'checkout'.tr(),
        style: AppTextStyle.styleBlack16Bold.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
