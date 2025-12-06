import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';

class NotLoggedInWidget extends StatelessWidget {
  final String resourceName;
  const NotLoggedInWidget({super.key, required this.resourceName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.lock,
            size: 60.sp,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'loginToView'.tr(args: [resourceName]),
            style: AppTextStyle.stylePrimary16Bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: CustomAppBottom(
              height: 50.h,
              backgroundColor: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12.r),
              horizontalPadding: 20.w,
              verticalPadding: 5.h,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoutesKeys.auth);
              },
              child: Text(
                'loginNow'.tr(),
                style: AppTextStyle.styleWhite17W700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
