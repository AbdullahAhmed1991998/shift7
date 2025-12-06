import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
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
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/categories_bannar_widget.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_horizontal_sub_categories_widget.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_item_card_widget.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';
import 'package:shift7_app/features/home/data/model/filtered_products_model.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_best_seller_list_view_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_new_arrivals_list_view_item_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_special_offer_list_viwe_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_tabs_widget.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final int depth;

  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.depth = 1,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  FilterModel currentFilter = FilterModel();
  bool _hasAppliedFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CategoriesCubit>();
      final homeCubit = context.read<HomeCubit>();
      cubit.initProductsList(widget.categoryId);
      homeCubit.initializeFiltersData(categoryId: widget.categoryId);
      _scrollController.addListener(_onScroll);
    });
  }

  bool _checkHasExtraFilters(FilterModel filter) {
    return (filter.selectedBrand != null && filter.selectedBrand!.isNotEmpty) ||
        (filter.selectedRating != null && filter.selectedRating!.isNotEmpty) ||
        filter.minPrice != null ||
        filter.maxPrice != null ||
        (filter.selectedCategory != null &&
            filter.selectedCategory!.length > 1) ||
        (filter.selectedCategory != null &&
            !filter.selectedCategory!.contains(widget.categoryId));
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final categoriesCubit = context.read<CategoriesCubit>();
    final homeCubit = context.read<HomeCubit>();
    final categoriesState = categoriesCubit.state;
    final homeState = homeCubit.state;

    if (_hasAppliedFilters) {
      if (homeState.filteredProductsState != ApiStatus.success ||
          !homeState.filteredProductsHasMore ||
          homeState.filteredProductsLoadingMore) {
        return;
      }

      final pos = _scrollController.position;
      if (pos.maxScrollExtent <= 0) {
        homeCubit.loadMoreFilteredProducts();
        return;
      }
      final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
      if (reached) {
        homeCubit.loadMoreFilteredProducts();
      }
    } else {
      if (categoriesState.productsListStatus != ApiStatus.success ||
          !categoriesState.productsListHasMore ||
          categoriesState.productsListLoadingMore) {
        return;
      }

      final pos = _scrollController.position;
      if (pos.maxScrollExtent <= 0) {
        categoriesCubit.loadMoreProductsList();
        return;
      }
      final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
      if (reached) {
        categoriesCubit.loadMoreProductsList();
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
          title: widget.categoryName.englishTitleCase(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state.productsListStatus == ApiStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state.productsListStatus == ApiStatus.error) {
              return Center(
                child: CustomHomeErrorWidget(
                  onRetry:
                      () => context.read<CategoriesCubit>().initProductsList(
                        widget.categoryId,
                      ),
                ),
              );
            }

            final categoryData = state.productsListData;
            if (categoryData == null) {
              return Center(
                child: CustomEmptyWidget(
                  message: 'noProductsOrSubcategories'.tr(),
                ),
              );
            }

            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                final originalProducts =
                    state.productsListItems.cast<ProductItemModel>();
                final filteredProducts =
                    homeState.filteredProductsList.cast<FilteredProduct>();

                final products =
                    _hasAppliedFilters ? filteredProducts : originalProducts;

                final subCategories = categoryData.subCategories;
                final hasProducts = products.isNotEmpty;
                final hasSubCategories = subCategories.isNotEmpty;
                final showProductsOnly = !hasSubCategories;

                final isLoadingMore =
                    _hasAppliedFilters
                        ? homeState.filteredProductsLoadingMore
                        : state.productsListLoadingMore;

                final isFilterLoading =
                    _hasAppliedFilters &&
                    homeState.filteredProductsState == ApiStatus.loading &&
                    filteredProducts.isEmpty;

                final shouldShowFilterUI = _hasAppliedFilters || hasProducts;

                if (showProductsOnly && isFilterLoading) {
                  return Column(
                    children: [
                      ProductFilterBar(
                        brands: homeState.brandsForFilter,
                        categories: homeState.categoriesForFilter,
                        currentFilter: currentFilter,
                        currentCategoryId: widget.categoryId,
                        onFilterChanged: _onFilterChanged,
                      ),
                      SizedBox(height: 8.h),
                      CustomDashedDivider(
                        color: Colors.grey[300]!,
                        height: 10.h,
                        thickness: 1,
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(16.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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

                if (!hasProducts && !hasSubCategories) {
                  if (showProductsOnly) {
                    if (_hasAppliedFilters) {
                      return Column(
                        children: [
                          ProductFilterBar(
                            brands: homeState.brandsForFilter,
                            categories: homeState.categoriesForFilter,
                            currentFilter: currentFilter,
                            currentCategoryId: widget.categoryId,
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
                          message: 'noProductsOrSubcategories'.tr(),
                        ),
                      );
                    }
                  }

                  return Center(
                    child: CustomEmptyWidget(
                      message: 'noProductsOrSubcategories'.tr(),
                    ),
                  );
                }

                final bannerOne = _getBannerByName(
                  categoryData.media,
                  'banner_one_image',
                );
                final bannerTwo = _getBannerByName(
                  categoryData.media,
                  'banner_two_image',
                );

                final bannerOneId = _getBannerId(
                  categoryData.media,
                  'banner_one_image',
                );
                final bannerTwoId = _getBannerId(
                  categoryData.media,
                  'banner_two_image',
                );

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (hasSubCategories) ...[
                      SliverToBoxAdapter(
                        child: _buildSubCategoriesSection(subCategories),
                      ),
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutesKeys.mediaLinksDetails,
                              arguments: {
                                'mediaId': bannerOneId,
                                'mediaName': "ourProducts".tr(),
                              },
                            );
                          },
                          child: CategoriesBannerWidget(
                            bannerUrl: bannerOne ?? "",
                          ),
                        ),
                      ),
                      if (hasProducts)
                        SliverToBoxAdapter(
                          child: _buildHorizontalProductsSection(
                            products,
                            isLoadingMore,
                          ),
                        ),
                      SliverToBoxAdapter(child: _buildAdditionalSpace()),
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutesKeys.mediaLinksDetails,
                              arguments: {
                                'mediaId': bannerTwoId,
                                'mediaName': "ourProducts".tr(),
                              },
                            );
                          },
                          child: CategoriesBannerWidget(
                            bannerUrl: bannerTwo ?? "",
                          ),
                        ),
                      ),
                    ] else if (showProductsOnly) ...[
                      if (shouldShowFilterUI)
                        SliverToBoxAdapter(
                          child: ProductFilterBar(
                            brands: homeState.brandsForFilter,
                            categories: homeState.categoriesForFilter,
                            currentFilter: currentFilter,
                            currentCategoryId: widget.categoryId,
                            onFilterChanged: _onFilterChanged,
                          ),
                        ),
                      if (shouldShowFilterUI)
                        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                      if (shouldShowFilterUI)
                        SliverToBoxAdapter(
                          child: CustomDashedDivider(
                            color: Colors.grey[300]!,
                            height: 10.h,
                            thickness: 1,
                          ),
                        ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= products.length) {
                                return const CustomCategoryDetailsLoadingCardWidget();
                              }

                              int productId;
                              Widget cardWidget;

                              if (_hasAppliedFilters) {
                                final filteredProduct = filteredProducts[index];

                                productId = filteredProduct.id;

                                final bool isArabic =
                                    getIt<CacheHelper>().getData(
                                      key: 'language',
                                    ) ==
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
                                  isFreeShipping:
                                      filteredProduct.hasFreeShipping,
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
                                        arguments: {
                                          "productId": filteredProduct.id,
                                        },
                                      ),
                                  onAddTap: null,
                                );
                              } else {
                                final originalProduct = originalProducts[index];
                                productId = originalProduct.id;

                                final bool isArabic =
                                    getIt<CacheHelper>().getData(
                                      key: 'language',
                                    ) ==
                                    'ar';

                                final String imageUrl =
                                    originalProduct
                                                .keyDefaultImage
                                                ?.isNotEmpty ==
                                            true
                                        ? ""
                                        : (originalProduct.media.isNotEmpty
                                            ? originalProduct.media.first.url
                                            : '');

                                final String title =
                                    isArabic
                                        ? originalProduct.nameAr
                                        : originalProduct.nameEn;
                                final String subTitle =
                                    isArabic
                                        ? (originalProduct.subNameAr ?? '')
                                        : (originalProduct.subNameEn ?? '');

                                final double priceAfterDiscount =
                                    originalProduct.discountedPrice;
                                final double? oldPrice =
                                    originalProduct.hasDiscount
                                        ? originalProduct.basePrice
                                        : null;

                                cardWidget = CustomItemCardWidget(
                                  imageUrl: imageUrl,
                                  title: title,
                                  subTitle: subTitle,
                                  price: priceAfterDiscount,
                                  oldPrice: oldPrice,
                                  isFreeShipping:
                                      originalProduct.hasFreeShipping,
                                  rating: originalProduct.totalRating,

                                  showSubtitle: subTitle.isNotEmpty,
                                  showPrice: true,
                                  useCartLogic: true,
                                  productId: originalProduct.id,
                                  defaultQuantity: 1,
                                  variantId: null,
                                  onTap:
                                      () => Navigator.pushNamed(
                                        context,
                                        AppRoutesKeys.product,
                                        arguments: {
                                          "productId": originalProduct.id,
                                        },
                                      ),
                                  onAddTap: null,
                                );
                              }

                              return GestureDetector(
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      AppRoutesKeys.product,
                                      arguments: {"productId": productId},
                                    ),
                                child: cardWidget,
                              );
                            },
                            childCount:
                                products.length + (isLoadingMore ? 2 : 0),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                                childAspectRatio: 160.w / 320.h,
                              ),
                        ),
                      ),
                    ],
                    if (isLoadingMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String? _getBannerByName(
    List<StoreMarketMediaModel> media,
    String bannerName,
  ) {
    final banners = media.where((m) => m.name == bannerName);
    final banner = banners.isNotEmpty ? banners.first : null;
    return banner?.url ?? "";
  }

  int? _getBannerId(List<StoreMarketMediaModel> media, String bannerName) {
    final banners = media.where((m) => m.name == bannerName);
    final banner = banners.isNotEmpty ? banners.first : null;
    return banner?.mediaLinks.id ?? 0;
  }

  Widget _buildSubCategoriesSection(List<CategoryItemModel> subCategories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        CustomHorizontalSubCategoriesWidget(
          subCategories: subCategories,
          parentDepth: widget.depth,
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildHorizontalProductsSection(
    List<dynamic> products,
    bool loadingMore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        SizedBox(
          height: 250.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: products.length + (loadingMore ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              if (loadingMore && index == products.length) {
                return const CustomCategoryDetailsLoadingCardWidget();
              }

              final product = products[index];
              int productId;
              Widget cardWidget;

              if (_hasAppliedFilters) {
                productId = product.id;
                cardWidget = CustomCategoryDetailsItemCardWidget(
                  filteredProduct: product,
                );
              } else {
                productId = product.id;
                cardWidget = CustomCategoryDetailsItemCardWidget(
                  product: product,
                );
              }

              return GestureDetector(
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      AppRoutesKeys.product,
                      arguments: {"productId": productId},
                    ),
                child: cardWidget,
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildAdditionalSpace() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        CustomSpecialOfferListViewWidget(categoryId: widget.categoryId),
        SizedBox(height: 15.h),
        CustomBestSellerListViewWidget(categoryId: widget.categoryId),
        SizedBox(height: 15.h),
        CustomNewArrivalsListViewItemWidget(categoryId: widget.categoryId),
        SizedBox(height: 10.h),
        CustomTabsWidget(id: widget.categoryId, tabType: 'category'),
      ],
    );
  }
}
