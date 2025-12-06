import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/categories/data/model/category_item_media_model.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';

class CategoryListRowWidget extends StatelessWidget {
  final List<CategoryItemModel> categories;
  const CategoryListRowWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return SizedBox(
      height: 135.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = categories[index];

          final imageUrl =
              item.media
                  .firstWhere(
                    (m) => m.name == 'category_image',
                    orElse:
                        () => CategoryItemMediaModel(id: 0, name: '', url: ''),
                  )
                  .url;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.categoryDetails,
                arguments: {
                  'categoryId': item.id,
                  'categoryName':
                      isArabic ? item.nameAr : item.nameEn.englishTitleCase(),
                },
              );
            },
            child: CategoryItemWidget(
              imageUrl: imageUrl,
              title: isArabic ? item.nameAr : item.nameEn.englishTitleCase(),
            ),
          );
        },
      ),
    );
  }
}
