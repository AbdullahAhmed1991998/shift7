import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/categories/data/model/category_args.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';

class CustomSubCategoriesGridWidget extends StatelessWidget {
  final List<CategoryItemModel> subCategories;
  final int parentDepth;
  const CustomSubCategoriesGridWidget({
    super.key,
    required this.subCategories,
    required this.parentDepth,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 50.w / 70.h,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = subCategories[index];
          final image =
              item.media.isNotEmpty
                  ? item.media.firstWhere(
                    (m) => m.name == 'category_image',
                    orElse: () => item.media.first,
                  )
                  : null;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.categoryDetails,
                arguments: CategoryArgs(
                  id: item.id,
                  name: isArabic ? item.nameAr : item.nameEn,
                  depth: parentDepth + 1,
                ),
              );
            },
            child: CategoryItemWidget(
              imageUrl: image?.url ?? '',
              title: isArabic ? item.nameAr : item.nameEn,
            ),
          );
        }, childCount: subCategories.length),
      ),
    );
  }
}
