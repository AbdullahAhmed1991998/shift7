import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomAttributesRow extends StatelessWidget {
  final String size;
  final Color color;
  final String colorName;
  const CustomAttributesRow({
    super.key,
    required this.size,
    required this.color,
    required this.colorName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 6.w),
        Text(colorName.toUpperCase(), style: AppTextStyle.styleBlack14W500),
        SizedBox(width: 8.w),
        Container(width: 1.w, height: 15.h, color: AppColors.blackColor),
        SizedBox(width: 8.w),
        Text(
          'sizeEquals'.tr(args: [size]),
          style: AppTextStyle.styleBlack14W500,
        ),
      ],
    );
  }
}
