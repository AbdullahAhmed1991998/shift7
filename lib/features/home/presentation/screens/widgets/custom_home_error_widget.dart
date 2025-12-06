import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shift7_app/core/utils/assets/app_lotties.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';

class CustomHomeErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool? hasRetry;
  const CustomHomeErrorWidget({super.key, this.onRetry, this.hasRetry});

  @override
  Widget build(BuildContext context) {
    final showRetry = (hasRetry == true) || (onRetry != null);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.biggest.shortestSide;
        final bool isTablet = shortestSide >= 600;
        return SizedBox(
          height: isTablet ? 270.h : 250.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppLotties.error, width: 160.w, height: 130.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "homeErrorMessage".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.styleBlack14W500,
                  ),
                ),
                SizedBox(height: 15.h),
                showRetry
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomAppBottom(
                        onTap: onRetry,
                        height: 50.h,
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                        horizontalPadding: 20.w,
                        verticalPadding: 5.h,
                        child: Text(
                          "retry".tr(),
                          style: AppTextStyle.styleWhite18Bold,
                        ),
                      ),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
