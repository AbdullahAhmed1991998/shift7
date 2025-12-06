import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/profile/data/models/get_my_orders_model.dart';

class MyOrdersProductMiniTile extends StatelessWidget {
  final OrderItemModel item;

  const MyOrdersProductMiniTile({super.key, required this.item});

  bool get _isArabic => getIt<CacheHelper>().getData(key: 'language') == 'ar';

  String _formatPrice(double value) {
    return formatJod(value, _isArabic);
  }

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final bool isArabicLocale =
        context.locale.languageCode.toLowerCase() == 'ar';
    final String title = isArabicLocale ? product.nameAr : product.nameEn;
    final String imageUrl =
        product.keyDefaultImage?.isNotEmpty == true
            ? product.keyDefaultImage!
            : (product.media.isNotEmpty ? product.media.first.url : '');
    final String priceStr = _formatPrice(item.price);
    final String qtyStr = 'x${item.quantity}';

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey[100],
            ),
            clipBehavior: Clip.antiAlias,
            child:
                imageUrl.isEmpty
                    ? Icon(
                      Icons.image_outlined,
                      size: 22.sp,
                      color: Colors.grey[400],
                    )
                    : Image.network(imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.styleBlack14W500,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(qtyStr, style: AppTextStyle.styleGrey12Bold),
                    Text(priceStr, style: AppTextStyle.styleBlack12W500),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
