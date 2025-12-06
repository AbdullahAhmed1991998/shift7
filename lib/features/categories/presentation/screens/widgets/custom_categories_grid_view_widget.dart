import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/categories/data/model/category_item_media_model.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/categories/data/model/get_markets_categories_model.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';

class CustomCategoriesGridViewWidget extends StatefulWidget {
  const CustomCategoriesGridViewWidget({super.key});

  @override
  State<CustomCategoriesGridViewWidget> createState() =>
      _CustomCategoriesGridViewWidgetState();
}

class _CustomCategoriesGridViewWidgetState
    extends State<CustomCategoriesGridViewWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasMarket =
          context.read<IntroCubit>().state.storeDetails?.store.hasMarket == 1;
      if (hasMarket) {
        context.read<CategoriesCubit>().initMarketsCategories();
      } else {
        context.read<CategoriesCubit>().initCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    final bool isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    final int cross = isTablet ? 4 : 3;
    final double mainGap = isTablet ? 10.h : 8.h;
    final double crossGap = 20.w;
    final double aspect = 3 / 4;

    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, storeState) {
        final hasMarket = storeState.storeDetails?.store.hasMarket == 1;

        if (hasMarket) {
          return BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state.marketsCategoriesStatus == ApiStatus.loading &&
                  state.marketsCategoriesItems.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      mainAxisSpacing: mainGap,
                      crossAxisSpacing: crossGap,
                      childAspectRatio: aspect,
                    ),
                    itemCount: 12,
                    itemBuilder:
                        (context, index) => const _CategoryLoadingTile(),
                  ),
                );
              }

              if (state.marketsCategoriesStatus == ApiStatus.error &&
                  state.marketsCategoriesItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      state.marketsCategoriesErrorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.styleBlack12W500.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }

              if (state.marketsCategoriesItems.isNotEmpty) {
                final markets = state.marketsCategoriesItems;
                final loadingMore = state.marketsCategoriesLoadingMore;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: markets.length + (loadingMore ? 1 : 0),
                  itemBuilder: (context, marketIndex) {
                    if (marketIndex >= markets.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final market = markets[marketIndex];
                    final marketName =
                        isArabic ? market.marketNameAr : market.marketNameEn;
                    final categories = market.categories.data;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: Text(
                            marketName,
                            style: AppTextStyle.styleBlack12W500.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 260.h,
                          child: _MarketCategoriesHorizontalGrid(
                            categories: categories,
                            isArabic: isArabic,
                            onReachedCheckpoint: () {
                              final s = context.read<CategoriesCubit>().state;
                              if (!s.marketsCategoriesLoadingMore &&
                                  s.marketsCategoriesHasMore) {
                                context
                                    .read<CategoriesCubit>()
                                    .loadMoreMarketsCategories();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  },
                );
              }

              return Center(
                child: CustomEmptyWidget(message: "noCategories".tr()),
              );
            },
          );
        }

        return BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state.status == ApiStatus.loading &&
                state.categoriesItems.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: mainGap,
                    crossAxisSpacing: crossGap,
                    childAspectRatio: aspect,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) => const _CategoryLoadingTile(),
                ),
              );
            }

            if (state.status == ApiStatus.error &&
                state.categoriesItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.styleBlack12W500.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }

            if (state.categoriesItems.isNotEmpty) {
              final List<CategoryItemModel> items = state.categoriesItems;
              final bool isLoadingMore = state.categoriesLoadingMore;
              final int extraPlaceholders = isLoadingMore ? 6 : 0;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: mainGap,
                    crossAxisSpacing: crossGap,
                    childAspectRatio: aspect,
                  ),
                  itemCount: items.length + extraPlaceholders,
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const _CategoryLoadingTile();
                    }

                    final item = items[index];
                    CategoryItemMediaModel? image;
                    if (item.media.isNotEmpty) {
                      image = item.media.firstWhere(
                        (m) => m.name == 'category_image',
                        orElse: () => item.media.first,
                      );
                    }

                    final nameAr = (item.nameAr).trim();
                    final nameEn = (item.nameEn).trim();
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
                ),
              );
            }

            return Center(
              child: CustomEmptyWidget(message: "noCategories".tr()),
            );
          },
        );
      },
    );
  }
}

class _MarketCategoriesHorizontalGrid extends StatefulWidget {
  final List<CategoryModel> categories;
  final bool isArabic;
  final VoidCallback onReachedCheckpoint;

  const _MarketCategoriesHorizontalGrid({
    required this.categories,
    required this.isArabic,
    required this.onReachedCheckpoint,
  });

  @override
  State<_MarketCategoriesHorizontalGrid> createState() =>
      _MarketCategoriesHorizontalGridState();
}

class _MarketCategoriesHorizontalGridState
    extends State<_MarketCategoriesHorizontalGrid> {
  bool _fired = false;

  @override
  void didUpdateWidget(covariant _MarketCategoriesHorizontalGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != oldWidget.categories.length) {
      _fired = false;
    }
  }

  bool _onScroll(ScrollNotification n) {
    final m = n.metrics;
    final colWidth = 100.w + 12.w;
    if (colWidth <= 0) return false;
    final endCol = ((m.pixels + m.viewportDimension) / colWidth).floor();
    final endIndex = (endCol * 2 - 1).clamp(0, widget.categories.length - 1);
    final reachedCount = (endIndex + 1).clamp(0, widget.categories.length);
    if (reachedCount >= 15 && !_fired) {
      _fired = true;
      widget.onReachedCheckpoint();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    final isArabic = widget.isArabic;

    const int rowCount = 2;
    final int columnCount = (categories.length / rowCount).ceil();

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.builder(
        primary: false,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: columnCount,
        itemBuilder: (context, columnIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(rowCount, (rowIndex) {
              final itemIndex = columnIndex * rowCount + rowIndex;
              if (itemIndex >= categories.length) {
                return SizedBox(width: 100.w, height: 130.h);
              }

              final category = categories[itemIndex];
              MediaModel? image;
              if (category.media.isNotEmpty) {
                image = category.media.firstWhere(
                  (m) => m.name == 'category_image',
                  orElse: () => category.media.first,
                );
              }

              final nameAr = category.nameAr.trim();
              final nameEn = category.nameEn.trim();
              final displayName =
                  isArabic
                      ? (nameAr.isNotEmpty ? nameAr : nameEn.englishTitleCase())
                      : (nameEn.isNotEmpty
                          ? nameEn.englishTitleCase()
                          : nameAr);

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
                child: Container(
                  width: 100.w,
                  height: 130.h,
                  margin: EdgeInsets.only(right: 12.w),
                  child: CategoryItemWidget(
                    imageUrl: image?.url ?? '',
                    title: displayName,
                  ),
                ),
              );
            }),
          );
        },
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
          width: 60.w,
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
