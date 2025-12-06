import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/categories/data/model/category_item_media_model.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';

class CustomHomeCategoryListWidget extends StatefulWidget {
  const CustomHomeCategoryListWidget({super.key});

  @override
  State<CustomHomeCategoryListWidget> createState() =>
      _CustomHomeCategoryListWidgetState();
}

class _CustomHomeCategoryListWidgetState
    extends State<CustomHomeCategoryListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().initCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        const itemHeight = 135.0;
        const spacing = 10.0;

        if (state.status == ApiStatus.initial ||
            state.status == ApiStatus.loading) {
          return _TwoRowsLoadingSkeleton(
            itemHeight: itemHeight.h,
            spacing: spacing.h,
          );
        }

        if (state.status == ApiStatus.error) {
          return const SizedBox.shrink();
        }

        final List<CategoryItemModel> items = state.categoriesItems;
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final firstRowCount = items.length >= 10 ? 10 : items.length;
        final firstRow = items.take(firstRowCount).toList();
        final secondRow = items.skip(firstRowCount).toList();

        final totalHeight =
            secondRow.isEmpty ? itemHeight.h : (itemHeight * 2 + spacing).h;

        final showTailLoader = state.categoriesLoadingMore;
        final tailPlaceholders = showTailLoader ? 4 : 0;

        return SizedBox(
          height: totalHeight,
          child: Column(
            children: [
              SizedBox(
                height: itemHeight.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  scrollDirection: Axis.horizontal,

                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final globalIndex = index;
                    final threshold = (items.length * 0.75).floor();
                    if (globalIndex >= threshold) {
                      context.read<CategoriesCubit>().loadMoreCategories();
                    }
                    final item = firstRow[index];
                    final CategoryItemMediaModel? image =
                        item.media.isNotEmpty
                            ? item.media.firstWhere(
                              (m) => m.name == 'category_image',
                              orElse: () => item.media.first,
                            )
                            : null;
                    final nameAr = item.nameAr.trim();
                    final nameEn = item.nameEn.trim();
                    final displayName =
                        isArabic
                            ? (nameAr.isNotEmpty
                                ? nameAr
                                : nameEn.englishTitleCase())
                            : (nameEn.isNotEmpty
                                ? nameEn.englishTitleCase()
                                : nameAr);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutesKeys.categoryDetails,
                          arguments: {
                            'categoryId': item.id,
                            'categoryName': displayName,
                          },
                        );
                      },
                      child: CategoryItemWidget(
                        imageUrl: image?.url ?? '',
                        title: displayName,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemCount: firstRow.length,
                ),
              ),
              if (secondRow.isNotEmpty) SizedBox(height: spacing.h),
              if (secondRow.isNotEmpty)
                SizedBox(
                  height: itemHeight.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    scrollDirection: Axis.horizontal,

                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= secondRow.length) {
                        return const _CategoryLoadingTile();
                      }
                      final globalIndex = firstRowCount + index;
                      final threshold = (items.length * 0.75).floor();
                      if (globalIndex >= threshold) {
                        context.read<CategoriesCubit>().loadMoreCategories();
                      }
                      final item = secondRow[index];
                      final CategoryItemMediaModel? image =
                          item.media.isNotEmpty
                              ? item.media.firstWhere(
                                (m) => m.name == 'category_image',
                                orElse: () => item.media.first,
                              )
                              : null;
                      final nameAr = item.nameAr.trim();
                      final nameEn = item.nameEn.trim();
                      final displayName =
                          isArabic
                              ? (nameAr.isNotEmpty ? nameAr : nameEn)
                              : (nameEn.isNotEmpty ? nameEn : nameAr);

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutesKeys.categoryDetails,
                            arguments: {
                              'categoryId': item.id,
                              'categoryName': displayName,
                            },
                          );
                        },
                        child: CategoryItemWidget(
                          imageUrl: image?.url ?? '',
                          title: displayName,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemCount: secondRow.length + tailPlaceholders,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TwoRowsLoadingSkeleton extends StatelessWidget {
  final double itemHeight;
  final double spacing;
  const _TwoRowsLoadingSkeleton({
    required this.itemHeight,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final totalHeight = itemHeight + (spacing > 0 ? spacing : 0) + itemHeight;
    return SizedBox(
      height: totalHeight,
      child: Column(
        children: [
          SizedBox(
            height: itemHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              scrollDirection: Axis.horizontal,

              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, __) => const _CategoryLoadingTile(),
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            height: itemHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              scrollDirection: Axis.horizontal,

              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, __) => const _CategoryLoadingTile(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryLoadingTile extends StatelessWidget {
  const _CategoryLoadingTile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 70.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}
