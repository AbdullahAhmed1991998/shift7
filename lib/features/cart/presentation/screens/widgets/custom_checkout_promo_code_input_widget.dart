import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCheckoutPromoCodeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onApply;

  const CustomCheckoutPromoCodeInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final hint = 'enterPromoCodeHere'.tr();

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: CustomAppFormField(
                controller: controller,
                borderRadius: 12.r,
                cursorColor: AppColors.primaryColor,
                cursorHeight: 20.h,
                autofocus: false,
                hintText: hint,
                hintStyle: AppTextStyle.styleGrey12Bold,
                maxLines: 1,
                onChanged: (v) => onChanged?.call(v),
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              height: 48.h,
              width: 110.w,
              child: CustomAppBottom(
                height: 48.h,
                backgroundColor: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  onChanged?.call(controller.text.trim());
                  onApply?.call();
                },
                child: Text(
                  'apply'.tr(),
                  style: AppTextStyle.styleBlack16Bold.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
