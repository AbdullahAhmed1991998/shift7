import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/app/data/models/product_reviews_model.dart';

class CustomReviewsListViewWidget extends StatelessWidget {
  final List<ProductReviewsModel> reviews;
  final bool isReviewPage;
  const CustomReviewsListViewWidget({
    super.key,
    required this.reviews,
    required this.isReviewPage,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    if (reviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Center(
          child: Text(
            'noReviews'.tr(),
            style: AppTextStyle.styleBlack16W500.copyWith(
              color: AppColors.greyColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            isReviewPage
                ? reviews.length
                : (reviews.length > 5 ? 5 : reviews.length),
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withAlpha(50),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.user.name,
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < review.rate ? Icons.star : Icons.star_border,
                            color: AppColors.secondaryColor,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    review.message,
                    style: AppTextStyle.styleBlack12W500.copyWith(
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment:
                        isArabic ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Text(
                      review.createdAt.toLocal().toString().split(' ')[0],
                      style: AppTextStyle.styleBlack12W400.copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
