import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCartPriceDisplay extends StatelessWidget {
  final double totalPrice;
  const CustomCartPriceDisplay({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'totalPrice'.tr(),
          style: AppTextStyle.styleBlack14W500.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 5.h),
        Text(
          formatJod(totalPrice, isArabic),
          style: AppTextStyle.stylePrimary20Bold.copyWith(
            color: AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }
}
