import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_cached_network_image.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

class CustomMarketCardItemWidget extends StatelessWidget {
  final StoreMarketModel market;
  const CustomMarketCardItemWidget({super.key, required this.market});

  String? getCategoryImageUrl() {
    try {
      return market.media
          .firstWhere((item) => item.name == 'category_image')
          .url;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    final imageUrl = getCategoryImageUrl();
    return SizedBox(
      width: 150.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 160.w,
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey[200],
            ),
            child: CustomCachedNetworkImage(
              imageUrl: imageUrl ?? '',
              height: 160.h,
              width: 160.w,
              radius: 12.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isArabic ? market.nameAr : market.nameEn.englishTitleCase(),
            style: AppTextStyle.styleBlack16Bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
