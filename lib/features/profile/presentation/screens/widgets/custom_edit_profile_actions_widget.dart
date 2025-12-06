import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomEditProfileActionsWidget extends StatelessWidget {
  const CustomEditProfileActionsWidget({
    super.key,
    required this.isEditMode,
    required this.onEdit,
    required this.onCancel,
    required this.onSave,
  });

  final bool isEditMode;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    if (!isEditMode) {
      return CustomAppBottom(
        onTap: onEdit,
        backgroundColor: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
        height: 50.h,
        width: double.infinity,
        child:
            Text(
              'editProfileTitle',
              style: AppTextStyle.styleWhite17W700,
              textAlign: TextAlign.center,
            ).tr(),
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomAppBottom(
            onTap: onCancel,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12.r),
            height: 50.h,
            width: double.infinity,
            child:
                Text(
                  'cancel',
                  style: AppTextStyle.styleGrey12Bold.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomAppBottom(
            onTap: onSave,
            backgroundColor: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12.r),
            height: 50.h,
            width: double.infinity,
            child:
                Text(
                  'update',
                  style: AppTextStyle.styleWhite17W700,
                  textAlign: TextAlign.center,
                ).tr(),
          ),
        ),
      ],
    );
  }
}
