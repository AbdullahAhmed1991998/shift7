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
import 'package:shift7_app/core/utils/widgets/custom_item_card_widget.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/category_item_widegt.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';

class MediaLinksDetailsScreen extends StatefulWidget {
  final String mediaName;
  final int mediaId;

  const MediaLinksDetailsScreen({
    super.key,
    required this.mediaName,
    required this.mediaId,
  });

  @override
  State<MediaLinksDetailsScreen> createState() =>
      _MediaLinksDetailsScreenState();
}

class _MediaLinksDetailsScreenState extends State<MediaLinksDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      cubit.fetchMediaLinksDetails(widget.mediaId);
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<HomeCubit>();
    final state = cubit.state;
    if (state.mediaLinksDetailsStatus != ApiStatus.success ||
        !state.mediaLinksDetailsHasMore ||
        state.mediaLinksDetailsLoadingMore) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) {
      cubit.loadMoreMediaLinksDetails();
      return;
    }
    final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
    if (reached) {
      cubit.loadMoreMediaLinksDetails();
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
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: widget.mediaName,
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.mediaLinksDetailsStatus == ApiStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state.mediaLinksDetailsStatus == ApiStatus.error) {
              return Center(
                child: CustomHomeErrorWidget(
                  onRetry:
                      () => context.read<HomeCubit>().fetchMediaLinksDetails(
                        widget.mediaId,
                      ),
                ),
              );
            }

            if (state.mediaLinksDetailsModel == null ||
                state.mediaLinksDetailsList.isEmpty) {
              return Center(
                child: CustomEmptyWidget(message: "noItemsInThisCategory".tr()),
              );
            }

            final model = state.mediaLinksDetailsModel!;
            final items = state.mediaLinksDetailsList;
            final isLoadingMore = state.mediaLinksDetailsLoadingMore;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (model.type == 2)
                  _buildCategoriesSliver(items, isArabic)
                else if (model.type == 1)
                  _buildProductsSliver(
                    items.cast<ProductItemModel>(),
                    isLoadingMore,
                  ),
                if (isLoadingMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSliver(List<dynamic> categories, bool isArabic) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = categories[index];
          final image =
              item.media.isNotEmpty
                  ? item.media.firstWhere(
                    (m) => m.name == 'category_image',
                    orElse: () => item.media.first,
                  )
                  : null;
          final nameAr = (item.nameAr ?? '').trim();
          final nameEn = (item.nameEn ?? '').trim();
          final displayName =
              isArabic
                  ? (nameAr.isNotEmpty ? nameAr : nameEn)
                  : (nameEn.isNotEmpty ? nameEn : nameAr);
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.categoryDetails,
                arguments: {'categoryId': item.id, 'categoryName': displayName},
              );
            },
            child: CategoryItemWidget(
              imageUrl: image?.url ?? '',
              title: displayName,
            ),
          );
        }, childCount: categories.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 50.w / 70.h,
        ),
      ),
    );
  }

  Widget _buildProductsSliver(
    List<ProductItemModel> products,
    bool loadingMore,
  ) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= products.length) {
            return const CustomCategoryDetailsLoadingCardWidget();
          }

          final product = products[index];

          final String imageUrl =
              product.keyDefaultImage?.isNotEmpty == true
                  ? ""
                  : (product.media.isNotEmpty ? product.media.first.url : '');

          final String title = isArabic ? product.nameAr : product.nameEn;
          final String subTitle =
              isArabic ? (product.subNameAr ?? '') : (product.subNameEn ?? '');

          final double priceAfterDiscount = product.discountedPrice;
          final double? oldPrice =
              product.hasDiscount ? product.basePrice : null;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.product,
                arguments: {'productId': product.id},
              );
            },
            child: CustomItemCardWidget(
              imageUrl: imageUrl,
              title: title,
              subTitle: subTitle,
              price: priceAfterDiscount,
              oldPrice: oldPrice,
              isFreeShipping: product.hasFreeShipping,
              rating: product.totalRating,

              showSubtitle: subTitle.isNotEmpty,
              showPrice: true,
              useCartLogic: true,
              productId: product.id,
              defaultQuantity: 1,
              variantId: null,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutesKeys.product,
                  arguments: {'productId': product.id},
                );
              },
              onAddTap: null,
            ),
          );
        }, childCount: products.length + (loadingMore ? 2 : 0)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 160.w / 320.h,
        ),
      ),
    );
  }
}
