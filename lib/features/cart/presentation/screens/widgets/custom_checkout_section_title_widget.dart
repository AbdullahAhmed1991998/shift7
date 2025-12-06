import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomCheckoutSectionTitleWidget extends StatelessWidget {
  final String title;
  final bool? hasLastText;
  final String? lastText;
  final VoidCallback? onLastTextTap;
  const CustomCheckoutSectionTitleWidget({
    super.key,
    required this.title,
    this.hasLastText = false,
    this.lastText,
    this.onLastTextTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyle.styleBlack16Bold),
            if (hasLastText == true)
              InkWell(
                onTap: onLastTextTap,
                child: Text(
                  lastText ?? '',
                  style: AppTextStyle.styleGrey12Bold.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
