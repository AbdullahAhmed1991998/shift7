import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:shift7_app/core/services/cache_helper.dart';

class CustomProductBottomBarWidget extends StatelessWidget {
  final bool isLoggedIn;
  final int isStockAvailable;
  final double basePrice;
  final double discountedPrice;
  final bool hasDiscount;
  final VoidCallback? onAddToCart;
  final VoidCallback onLogin;

  const CustomProductBottomBarWidget({
    super.key,
    required this.isLoggedIn,
    required this.onLogin,
    required this.isStockAvailable,
    required this.basePrice,
    required this.discountedPrice,
    required this.hasDiscount,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    final String priceStr = formatJod(discountedPrice, isArabic);
    final String? oldPriceStr =
        hasDiscount ? formatJod(basePrice, isArabic) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDashedDivider(
          color: Colors.grey[300]!,
          height: 10.h,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child:
              isLoggedIn
                  ? Row(
                    mainAxisAlignment:
                        isArabic
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'totalPrice'.tr(),
                              style: AppTextStyle.styleBlack12W500.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    priceStr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.stylePrimary20Bold,
                                  ),
                                ),
                                if (oldPriceStr != null &&
                                    basePrice > discountedPrice) ...[
                                  SizedBox(width: 6.w),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      oldPriceStr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.styleBlack14W500
                                          .copyWith(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      isStockAvailable == 0
                          ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                              'outOfStock'.tr(),
                              style: AppTextStyle.styleBlack16Bold.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          )
                          : SizedBox(
                            width:
                                hasDiscount == true
                                    ? MediaQuery.sizeOf(context).width * .45
                                    : double.infinity,
                            child: CustomAppBottom(
                              height: 50.h,
                              verticalPadding: 8.h,
                              horizontalPadding:
                                  hasDiscount == true ? 20.w : 40.w,
                              backgroundColor: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: onAddToCart,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    color: AppColors.whiteColor,
                                    size: hasDiscount == true ? 18.sp : 20.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'addToCart'.tr(),
                                    style:
                                        hasDiscount == true
                                            ? AppTextStyle.styleBlack16Bold
                                                .copyWith(
                                                  color: AppColors.whiteColor,
                                                )
                                            : AppTextStyle.styleBlack18Bold
                                                .copyWith(
                                                  color: AppColors.whiteColor,
                                                ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  )
                  : SizedBox(
                    width: double.infinity,
                    child: CustomAppBottom(
                      height: 50.h,
                      verticalPadding: 12.5.h,
                      horizontalPadding: 20.w,
                      backgroundColor: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: onLogin,
                      child: Text(
                        'loginToContinue'.tr(),
                        style: AppTextStyle.styleWhite17W700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
