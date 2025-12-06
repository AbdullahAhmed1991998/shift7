import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomLeadingBadgeWidget extends StatelessWidget {
  const CustomLeadingBadgeWidget({super.key, required this.unread});
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              unread
                  ? [AppColors.primaryColor, AppColors.blackColor]
                  : [AppColors.secondaryColor, AppColors.blackColor],
        ),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.bell,
          size: 18.sp,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
