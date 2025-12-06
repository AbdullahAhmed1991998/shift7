import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCheckoutOrderItemWidget extends StatelessWidget {
  final int index;
  final CartItemModel item;

  const CustomCheckoutOrderItemWidget({
    super.key,
    required this.index,
    required this.item,
  });

  double _unitPrice() {
    final raw =
        item.variantId == null ? item.product.basePrice : item.variant?.price;
    return double.tryParse(raw.toString()) ?? 0.0;
  }

  String _imageUrl() {
    final fallback = item.product.keyDefaultImage;
    final fromMedia =
        (item.product.media.isNotEmpty) ? item.product.media.first.url : null;
    return (fromMedia?.isNotEmpty ?? false) ? fromMedia! : fallback;
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final unit = _unitPrice();
    final qty = item.quantity;

    final nameAr = item.product.nameAr;
    final nameEn = item.product.nameEn;
    final name =
        isArabic
            ? ((nameAr.trim().isNotEmpty) ? nameAr : nameEn)
            : ((nameEn.trim().isNotEmpty) ? nameEn : nameAr);

    final double discountPerUnit = item.product.totalDiscountsValue;
    final bool hasDiscount = discountPerUnit > 0;
    final double originalTotal = unit * qty;
    double discountedTotal = originalTotal;
    if (hasDiscount) {
      final double perUnitAfterDiscount = unit - discountPerUnit;
      final double safePerUnit =
          perUnitAfterDiscount < 0 ? 0 : perUnitAfterDiscount;
      discountedTotal = safePerUnit * qty;
    }

    return Container(
      height: 160.h,
      margin: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.greyColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(32),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: SizedBox(
                width: 120.w,
                height: 140.h,
                child: CachedNetworkImage(
                  imageUrl: _imageUrl(),
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.secondaryColor,
                          size: 28.sp,
                        ),
                      ),
                  errorWidget:
                      (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10.h,
                bottom: 10.h,
                left: 5.w,
                right: 10.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.styleBlack16Bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total'.tr(),
                        style: AppTextStyle.stylePrimary15Bold,
                      ),
                      Row(
                        children: [
                          if (hasDiscount)
                            Text(
                              formatJod(originalTotal, isArabic),
                              style: AppTextStyle.styleBlack16Bold.copyWith(
                                color: Colors.grey,
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (hasDiscount) SizedBox(width: 6.w),
                          Text(
                            formatJod(discountedTotal, isArabic),
                            style: AppTextStyle.styleSecondary18Bold.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 17.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'quantity'.tr(),
                        style: AppTextStyle.stylePrimary15Bold,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Center(
                          child: Text(
                            '$qty',
                            style: AppTextStyle.stylePrimary15Bold.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
