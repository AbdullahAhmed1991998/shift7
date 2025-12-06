import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'custom_highlighted_text_widget.dart';
import 'package:shift7_app/features/app/data/models/search_brand_model.dart';

class CustomBrandItemWidget extends StatelessWidget {
  final SearchBrandModel brand;
  final String query;
  final VoidCallback? onTap;

  const CustomBrandItemWidget({
    super.key,
    required this.brand,
    required this.query,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 3, child: _buildCategoryImage()),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: CustomHighlightedTextWidget(
                            text: _getCategoryName(),
                            query: query,
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    final imageUrl = brand.media.isNotEmpty ? brand.media[0].url : '';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.grey[100]!],
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildSkeletonLoader(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[100]!, Colors.grey[200]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 60.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withAlpha(5),
            AppColors.primaryColor.withAlpha(10),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(35),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Icon(Icons.image, color: AppColors.primaryColor, size: 28.w),
          ),
        ),
      ),
    );
  }

  String _getCategoryName() {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    if (brand.nameAr.isNotEmpty && isArabic == true) {
      return brand.nameAr;
    } else if (brand.nameEn.isNotEmpty && isArabic == false) {
      return brand.nameEn;
    }
    return '';
  }
}
