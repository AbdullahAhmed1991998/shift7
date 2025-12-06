import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomProfileItemWidget extends StatelessWidget {
  final IconData iconPath;
  final String titleKey;
  final String suffixType;
  final bool? isSwitchEnabled;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  const CustomProfileItemWidget({
    super.key,
    required this.iconPath,
    required this.titleKey,
    required this.suffixType,
    this.isSwitchEnabled,
    this.onSwitchChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLogout = titleKey == 'logout';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(24),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 2.r,
                offset: Offset(0, 1.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 38.r,
                  width: 38.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isLogout ? Colors.red : AppColors.secondaryColor)
                        .withAlpha(25),
                  ),
                  child: Center(
                    child: Icon(
                      iconPath,
                      size: 22.sp,
                      color: isLogout ? Colors.red : AppColors.secondaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child:
                      Text(
                        titleKey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (isLogout
                                ? AppTextStyle.styleBlack16W500.copyWith(
                                  color: Colors.red,
                                )
                                : AppTextStyle.styleBlack16W500)
                            .copyWith(height: 1.2),
                      ).tr(),
                ),
                SizedBox(width: 8.w),
                if (suffixType == 'switch')
                  Switch(
                    value: isSwitchEnabled ?? false,
                    onChanged: onSwitchChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeThumbColor: AppColors.whiteColor,
                    activeTrackColor: AppColors.secondaryColor,
                    inactiveTrackColor: Colors.grey[300],
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: isLogout ? Colors.red : AppColors.secondaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
