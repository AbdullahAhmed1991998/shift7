import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_title_row.dart';
import 'package:shift7_app/features/favorite/data/models/get_favourite_model.dart';
import 'package:shift7_app/features/favorite/presentation/screens/widgets/custom_price_text.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';

class CustomCardContent extends StatelessWidget {
  final WishlistItemModel product;
  final bool isFavorite;
  final Animation<double> scaleAnimation;
  final VoidCallback onToggleFavorite;

  const CustomCardContent({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.scaleAnimation,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    final nameAr = product.nameAr;
    final nameEn = product.nameEn;
    final title =
        isArabic
            ? (nameAr.trim().isNotEmpty ? nameAr : nameEn)
            : (nameEn.trim().isNotEmpty ? nameEn : nameAr);

    final priceText = formatJod(product.basePrice, isArabic);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTitleRow(title: title, onDelete: onToggleFavorite),
          SizedBox(height: 8.h),
          Text(
            isArabic ? product.subNameAr : product.subNameEn,
            style: AppTextStyle.styleBlack14W500.copyWith(color: Colors.grey),
            maxLines: 4,
          ),
          SizedBox(height: 8.h),
          Row(children: [Spacer(), CustomPriceText(price: priceText)]),
        ],
      ),
    );
  }
}
