import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/enums/search_tab.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'custom_empty_state_widget.dart';
import 'custom_loading_state_widget.dart';
import 'custom_category_item_widget.dart';
import 'custom_brand_item_widget.dart';
import 'custom_product_item_widget.dart';

class CustomSearchResultsWidget extends StatelessWidget {
  final String currentQuery;
  final SearchTab selectedTab;
  final Animation<double> fadeAnimation;
  final VoidCallback onRetry;

  const CustomSearchResultsWidget({
    super.key,
    required this.currentQuery,
    required this.selectedTab,
    required this.fadeAnimation,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, state) {
        if (currentQuery.isEmpty) {
          return CustomEmptyStateWidget(
            message: 'searchOnProductsCategoriesAndBrands'.tr(),
            icon: Icons.search_rounded,
          );
        }

        if (state.searchStatus == ApiStatus.loading) {
          return const CustomLoadingStateWidget();
        }

        if (state.searchStatus == ApiStatus.error) {
          return CustomHomeErrorWidget(hasRetry: true, onRetry: onRetry);
        }

        if (state.searchStatus == ApiStatus.success &&
            state.searchResults != null) {
          return FadeTransition(
            opacity: fadeAnimation,
            child: _buildResultsList(state.searchResults!, context),
          );
        }

        return CustomEmptyStateWidget(
          message: 'noSearchResults'.tr(),
          icon: Icons.search_off,
        );
      },
    );
  }

  Widget _buildResultsList(dynamic searchResults, BuildContext context) {
    switch (selectedTab) {
      case SearchTab.categories:
        return _buildCategoriesList(
          searchResults.data?.categories ?? [],
          context,
        );
      case SearchTab.brands:
        return _buildBrandsList(searchResults.data?.brands ?? [], context);
      case SearchTab.products:
        return _buildProductsList(searchResults.data?.products ?? [], context);
    }
  }

  Widget _buildCategoriesList(List categories, BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    if (categories.isEmpty) {
      return CustomEmptyStateWidget(
        message: 'noCategories'.tr(),
        icon: Icons.search_off,
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final displayName =
            isArabic
                ? (category.nameAr.isNotEmpty
                    ? category.nameAr
                    : category.nameEn)
                : (category.nameEn.isNotEmpty
                    ? category.nameEn
                    : category.nameAr);
        return CustomCategoryItemWidget(
          category: category,
          query: currentQuery,
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
        );
      },
    );
  }

  Widget _buildBrandsList(List brands, BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    if (brands.isEmpty) {
      return CustomEmptyStateWidget(
        message: 'noBrands'.tr(),
        icon: Icons.search_off,
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      physics: const BouncingScrollPhysics(),
      itemCount: brands.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final brand = brands[index];
        final displayName =
            isArabic
                ? (brand.nameAr.isNotEmpty ? brand.nameAr : brand.nameEn)
                : (brand.nameEn.isNotEmpty ? brand.nameEn : brand.nameAr);
        return CustomBrandItemWidget(
          brand: brand,
          query: currentQuery,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutesKeys.brandDetails,
              arguments: {'brandId': brand.id, 'brandName': displayName},
            );
          },
        );
      },
    );
  }

  Widget _buildProductsList(List products, BuildContext context) {
    if (products.isEmpty) {
      return CustomEmptyStateWidget(
        message: 'noProducts'.tr(),
        icon: Icons.search_off,
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return CustomProductItemWidget(
          product: product,
          query: currentQuery,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutesKeys.product,
              arguments: {"productId": product.id},
            );
          },
        );
      },
    );
  }
}
