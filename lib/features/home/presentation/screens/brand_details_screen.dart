import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/product_filter_bar.dart';
import 'package:shift7_app/core/utils/widgets/custom_item_card_widget.dart';
import 'package:shift7_app/features/app/data/models/filter_model.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';
import 'package:shift7_app/features/home/data/model/filtered_products_model.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';

class BrandDetailsScreen extends StatefulWidget {
  final String brandName;
  final int brandId;

  const BrandDetailsScreen({
    super.key,
    required this.brandName,
    required this.brandId,
  });

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  FilterModel currentFilter = FilterModel();
  bool _hasAppliedFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      cubit.initBrandDetails(widget.brandId);
      cubit.initializeFiltersData(brandId: widget.brandId);
      _scrollController.addListener(_onScroll);
    });
  }

  bool _checkHasExtraFilters(FilterModel filter) {
    return (filter.selectedCategory != null &&
            filter.selectedCategory!.isNotEmpty) ||
        (filter.selectedRating != null && filter.selectedRating!.isNotEmpty) ||
        filter.minPrice != null ||
        filter.maxPrice != null ||
        (filter.selectedBrand != null && filter.selectedBrand!.length > 1) ||
        (filter.selectedBrand != null &&
            !filter.selectedBrand!.contains(widget.brandId));
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<HomeCubit>();
    final state = cubit.state;

    if (_hasAppliedFilters) {
      if (state.filteredProductsState != ApiStatus.success ||
          !state.filteredProductsHasMore ||
          state.filteredProductsLoadingMore) {
        return;
      }

      final pos = _scrollController.position;
      if (pos.maxScrollExtent <= 0) {
        cubit.loadMoreFilteredProducts();
        return;
      }
      final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
      if (reached) {
        cubit.loadMoreFilteredProducts();
      }
    } else {
      if (state.brandDetailsStatus != ApiStatus.success ||
          !state.brandHasMore ||
          state.brandLoadingMore) {
        return;
      }

      final pos = _scrollController.position;
      if (pos.maxScrollExtent <= 0) {
        cubit.loadMoreBrandDetails();
        return;
      }
      final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
      if (reached) {
        cubit.loadMoreBrandDetails();
      }
    }
  }

  void _onFilterChanged(FilterModel newFilter) {
    final hasExtraFilters = _checkHasExtraFilters(newFilter);

    setState(() {
      currentFilter = newFilter;
      _hasAppliedFilters = hasExtraFilters;
    });

    if (hasExtraFilters) {
      context.read<HomeCubit>().getFilteredProducts(newFilter);
    } else {
      context.read<HomeCubit>().clearFilteredProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: widget.brandName,
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final brandProducts = state.brandItems.cast<ProductItemModel>();
            final filteredProducts =
                state.filteredProductsList.cast<FilteredProduct>();
            final products =
                _hasAppliedFilters ? filteredProducts : brandProducts;

            final isLoading =
                _hasAppliedFilters
                    ? (state.filteredProductsState == ApiStatus.loading &&
                        filteredProducts.isEmpty)
                    : (state.brandDetailsStatus == ApiStatus.loading &&
                        brandProducts.isEmpty);

            final hasError =
                _hasAppliedFilters
                    ? state.filteredProductsState == ApiStatus.error
                    : state.brandDetailsStatus == ApiStatus.error;

            final isLoadingMore =
                _hasAppliedFilters
                    ? state.filteredProductsLoadingMore
                    : state.brandLoadingMore;

            final isSuccess =
                _hasAppliedFilters
                    ? state.filteredProductsState == ApiStatus.success
                    : state.brandDetailsStatus == ApiStatus.success;

            final hasProducts = products.isNotEmpty;
            final shouldShowFilterUI = _hasAppliedFilters || hasProducts;

            if (isLoading) {
              return Column(
                children: [
                  if (shouldShowFilterUI)
                    ProductFilterBar(
                      brands: state.brandsForFilter,
                      categories: state.categoriesForFilter,
                      currentFilter: currentFilter,
                      currentBrandId: widget.brandId,
                      onFilterChanged: _onFilterChanged,
                    ),
                  if (shouldShowFilterUI) SizedBox(height: 8.h),
                  if (shouldShowFilterUI)
                    CustomDashedDivider(
                      color: Colors.grey[300]!,
                      height: 10.h,
                      thickness: 1,
                    ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 160.w / 320.h,
                      ),
                      itemCount: 6,
                      itemBuilder:
                          (context, index) =>
                              const CustomCategoryDetailsLoadingCardWidget(),
                    ),
                  ),
                ],
              );
            }

            if (hasError) {
              return Center(
                child: CustomHomeErrorWidget(
                  onRetry: () {
                    if (_hasAppliedFilters && currentFilter.hasFilters) {
                      context.read<HomeCubit>().getFilteredProducts(
                        currentFilter,
                      );
                    } else {
                      context.read<HomeCubit>().initBrandDetails(
                        widget.brandId,
                      );
                      context.read<HomeCubit>().initializeFiltersData(
                        brandId: widget.brandId,
                      );
                    }
                  },
                ),
              );
            }

            if (products.isEmpty && isSuccess) {
              if (_hasAppliedFilters) {
                return Column(
                  children: [
                    ProductFilterBar(
                      brands: state.brandsForFilter,
                      categories: state.categoriesForFilter,
                      currentFilter: currentFilter,
                      currentBrandId: widget.brandId,
                      onFilterChanged: _onFilterChanged,
                    ),
                    SizedBox(height: 8.h),
                    CustomDashedDivider(
                      color: Colors.grey[300]!,
                      height: 10.h,
                      thickness: 1,
                    ),
                    Expanded(
                      child: Center(
                        child: CustomEmptyWidget(
                          message: "noProductsFoundWithTheseFilters".tr(),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CustomEmptyWidget(
                    message: "noProductsFoundInThisBrand".tr(),
                  ),
                );
              }
            }

            return Column(
              children: [
                if (shouldShowFilterUI)
                  ProductFilterBar(
                    brands: state.brandsForFilter,
                    categories: state.categoriesForFilter,
                    currentFilter: currentFilter,
                    currentBrandId: widget.brandId,
                    onFilterChanged: _onFilterChanged,
                  ),
                if (shouldShowFilterUI) SizedBox(height: 8.h),
                if (shouldShowFilterUI)
                  CustomDashedDivider(
                    color: Colors.grey[300]!,
                    height: 10.h,
                    thickness: 1,
                  ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 160.w / 320.h,
                    ),
                    itemCount: products.length + (isLoadingMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= products.length) {
                        return const CustomCategoryDetailsLoadingCardWidget();
                      }

                      int productId;
                      Widget cardWidget;

                      if (_hasAppliedFilters) {
                        final filteredProduct = filteredProducts[index];
                        productId = filteredProduct.id;

                        final bool isArabic =
                            getIt<CacheHelper>().getData(key: 'language') ==
                            'ar';

                        final String imageUrl =
                            filteredProduct.hasMediaImages
                                ? filteredProduct.primaryImage
                                : '';

                        final String title =
                            isArabic
                                ? filteredProduct.nameAr
                                : filteredProduct.nameEn;
                        final String subTitle =
                            isArabic
                                ? filteredProduct.subNameAr
                                : filteredProduct.subNameEn;

                        final double priceAfterDiscount =
                            filteredProduct.discountedPrice;
                        final double? oldPrice =
                            filteredProduct.hasDiscount
                                ? filteredProduct.basePriceDouble
                                : null;

                        cardWidget = CustomItemCardWidget(
                          imageUrl: imageUrl,
                          title: title,
                          subTitle: subTitle,
                          price: priceAfterDiscount,
                          oldPrice: oldPrice,
                          isFreeShipping: filteredProduct.hasFreeShipping,
                          rating: filteredProduct.totalRating,

                          showSubtitle: subTitle.isNotEmpty,
                          showPrice: true,
                          useCartLogic: true,
                          productId: filteredProduct.id,
                          defaultQuantity: 1,
                          variantId: null,
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutesKeys.product,
                                arguments: {"productId": filteredProduct.id},
                              ),
                          onAddTap: null,
                        );
                      } else {
                        final brandProduct = brandProducts[index];
                        productId = brandProduct.id;

                        final bool isArabic =
                            getIt<CacheHelper>().getData(key: 'language') ==
                            'ar';

                        final String imageUrl =
                            brandProduct.keyDefaultImage?.isNotEmpty == true
                                ? ""
                                : (brandProduct.media.isNotEmpty
                                    ? brandProduct.media.first.url
                                    : '');

                        final String title =
                            isArabic
                                ? brandProduct.nameAr
                                : brandProduct.nameEn;
                        final String subTitle =
                            isArabic
                                ? (brandProduct.subNameAr ?? '')
                                : (brandProduct.subNameEn ?? '');

                        final double priceAfterDiscount =
                            brandProduct.discountedPrice;
                        final double? oldPrice =
                            brandProduct.hasDiscount
                                ? brandProduct.basePrice
                                : null;

                        cardWidget = CustomItemCardWidget(
                          imageUrl: imageUrl,
                          title: title,
                          subTitle: subTitle,
                          price: priceAfterDiscount,
                          oldPrice: oldPrice,
                          isFreeShipping: brandProduct.hasFreeShipping,
                          rating: brandProduct.totalRating,

                          showSubtitle: subTitle.isNotEmpty,
                          showPrice: true,
                          useCartLogic: true,
                          productId: brandProduct.id,
                          defaultQuantity: 1,
                          variantId: null,
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutesKeys.product,
                                arguments: {"productId": brandProduct.id},
                              ),
                          onAddTap: null,
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutesKeys.product,
                            arguments: {"productId": productId},
                          );
                        },
                        child: cardWidget,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
