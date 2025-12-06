import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shift7_app/core/utils/assets/app_lotties.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String message;
  const CustomEmptyWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.biggest.shortestSide;
        final bool isTablet = shortestSide >= 600;
        return SizedBox(
          height: isTablet ? 240.h : 220.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppLotties.empty, width: 160.w, height: 160.h),
                SizedBox(height: 5.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.styleBlack14W500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
