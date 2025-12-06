import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';

class CustomHorizontalSubCategoriesWidget extends StatelessWidget {
  final List<CategoryItemModel> subCategories;
  final int parentDepth;

  const CustomHorizontalSubCategoriesWidget({
    super.key,
    required this.subCategories,
    required this.parentDepth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return SizedBox(
      height: 160.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final category = subCategories[index];
          final String? imageUrl =
              (category.media.isNotEmpty)
                  ? category.media.first.url as String?
                  : null;
          final nameAr = (category.nameAr).trim();
          final nameEn = (category.nameEn).trim();
          final displayName =
              isArabic
                  ? (nameAr.isNotEmpty ? nameAr : nameEn.englishTitleCase())
                  : (nameEn.isNotEmpty ? nameEn.englishTitleCase() : nameAr);

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.categoryDetails,
                arguments: {
                  'categoryId': category.id,
                  'categoryName': displayName,
                },
              );
            },
            child: CategoryItemWidget(
              imageUrl: imageUrl ?? '',
              title: displayName,
            ),
          );
        },
      ),
    );
  }
}
