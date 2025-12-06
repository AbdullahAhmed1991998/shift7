import 'package:flutter/material.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_cached_network_image.dart';
import 'package:shift7_app/features/home/data/model/custom_tabs_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabsCardWidget extends StatelessWidget {
  final CustomTabDetail item;
  const CustomTabsCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return SizedBox(
      width: 160.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 160.w,
            height: 213.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CustomCachedNetworkImage(
              imageUrl: item.media[0].url,
              height: 160.h,
              width: 160.w,
              radius: 12.r,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              isArabic ? item.nameAr : item.nameEn.englishTitleCase(),
              style: AppTextStyle.styleBlack16W500,
            ),
          ),
        ],
      ),
    );
  }
}
