import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';

class CustomSvgAppIconWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomSvgAppIconWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppIcons.appIcon,
      height: height ?? 45.h,
      width: width ?? 82.w,
      colorFilter: ColorFilter.mode(
        Colors.grey[700]!.withAlpha(50),
        BlendMode.srcIn,
      ),
    );
  }
}
