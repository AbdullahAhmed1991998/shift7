import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: RotatedBox(
                quarterTurns: isArabic ? 2 : 4,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.blackColor,
                  size: 20.sp,
                ),
              ),
              onPressed: () => onBackPressed(),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              constraints: const BoxConstraints(),
            ),
          ),
          Text(
            title,
            style: AppTextStyle.styleBlack18Bold.copyWith(fontSize: 17.sp),
          ),
        ],
      ),
    );
  }
}
