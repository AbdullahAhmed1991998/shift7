import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_delete_button_widget.dart';
import 'custom_cart_qty_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCartCardContentWidget extends StatelessWidget {
  final CartItemModel item;
  final int quantity;
  final bool isDirty;
  final bool isUpdating;
  final bool disableActions;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const CustomCartCardContentWidget({
    super.key,
    required this.item,
    required this.quantity,
    required this.isDirty,
    required this.isUpdating,
    required this.disableActions,
    required this.onQuantityChanged,
    required this.onUpdate,
    required this.onDelete,
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
    final unit = _unitPrice();
    final bool isArabic = context.locale.languageCode == 'ar';
    final productName =
        isArabic
            ? ((item.product.nameAr.trim().isNotEmpty)
                ? item.product.nameAr
                : item.product.nameEn)
            : item.product.nameEn;

    final double discountPerUnit = item.product.totalDiscountsValue;
    final bool hasDiscount = discountPerUnit > 0;
    final double originalTotal = unit * quantity;
    double discountedTotal = originalTotal;
    if (hasDiscount) {
      final double perUnitAfterDiscount = unit - discountPerUnit;
      final double safePerUnit =
          perUnitAfterDiscount < 0 ? 0 : perUnitAfterDiscount;
      discountedTotal = safePerUnit * quantity;
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    AppRoutesKeys.product,
                    arguments: {"productId": item.productId},
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 110.w,
                  height: 110.w,
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl(),
                    fit: BoxFit.cover,
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
            SizedBox(width: 10.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Text(
                            productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.styleBlack16Bold,
                          ),
                        ),
                        const Spacer(),
                        CustomCartDeleteButtonWidget(
                          onTap:
                              (disableActions || isUpdating) ? null : onDelete,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'price'.tr(),
                          style: AppTextStyle.styleBlack16Bold.copyWith(
                            color: AppColors.primaryColor,
                          ),
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
                              style: AppTextStyle.styleBlack16Bold.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'quantity'.tr(),
                          style: AppTextStyle.styleBlack16Bold.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            CustomCartQtyButtonWidget(
                              icon: Icons.remove,
                              onTap:
                                  (disableActions ||
                                          isUpdating ||
                                          quantity <= 1)
                                      ? null
                                      : () => onQuantityChanged(quantity - 1),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '$quantity',
                              style: AppTextStyle.styleBlack16Bold,
                            ),
                            SizedBox(width: 10.w),
                            CustomCartQtyButtonWidget(
                              icon: Icons.add,
                              onTap:
                                  (disableActions || isUpdating)
                                      ? null
                                      : () => onQuantityChanged(quantity + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isDirty) ...[
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: (isUpdating || disableActions) ? null : onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child:
                  isUpdating
                      ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColors.secondaryColor,
                            size: 30.sp,
                          ),
                        ),
                      )
                      : Text(
                        'update'.tr(),
                        style: AppTextStyle.styleWhite17W700.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
        ],
      ],
    );
  }
}
