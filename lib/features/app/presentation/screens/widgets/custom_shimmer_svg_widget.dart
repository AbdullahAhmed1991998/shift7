import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';

class CustomShimmerSvgWidget extends StatelessWidget {
  const CustomShimmerSvgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AppIcons.appIcon, height: 45.h, width: 82.w);
  }
}
