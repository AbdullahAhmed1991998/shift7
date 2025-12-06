import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomSkipButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSkipButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.h,
      right: 10.w,
      child: TextButton(
        onPressed: onPressed,
        child: Text("skip".tr(), style: AppTextStyle.styleWhite18W500),
      ),
    );
  }
}
