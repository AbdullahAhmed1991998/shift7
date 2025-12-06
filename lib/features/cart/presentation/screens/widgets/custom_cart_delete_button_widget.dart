import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';

class CustomCartDeleteButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomCartDeleteButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: SvgPicture.asset(AppIcons.deleteIcon, width: 25.w, height: 25.w),
    );
  }
}
