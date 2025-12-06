import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/profile/data/models/get_user_address_model.dart';

import '../../../../../core/utils/assets/app_icons.dart';

class CustomLocationItemWidget extends StatelessWidget {
  final AddressModel address;
  final VoidCallback? onDelete;
  final bool deleting;

  const CustomLocationItemWidget({
    super.key,
    required this.address,
    this.onDelete,
    this.deleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(28), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(24),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryColor, AppColors.blackColor],
                ),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: AppColors.whiteColor,
                  size: 22.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.addressLine1,
                    style: AppTextStyle.styleBlack14W500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${address.addressLine2} - ${address.city} - ${address.country}",
                    style: AppTextStyle.styleBlack12W500.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              height: 40.h,
              child:
                  deleting
                      ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      )
                      : InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(8.r),
                        child: SvgPicture.asset(
                          AppIcons.deleteIcon,
                          width: 25.w,
                          height: 25.w,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
