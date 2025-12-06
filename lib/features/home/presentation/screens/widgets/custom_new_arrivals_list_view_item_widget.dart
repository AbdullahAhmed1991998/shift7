import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_item_card_widget.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';

class CustomNewArrivalsListViewItemWidget extends StatefulWidget {
  final int categoryId;

  const CustomNewArrivalsListViewItemWidget({super.key, this.categoryId = 0});

  @override
  State<CustomNewArrivalsListViewItemWidget> createState() =>
      _CustomNewArrivalsListViewItemWidgetState();
}

class _CustomNewArrivalsListViewItemWidgetState
    extends State<CustomNewArrivalsListViewItemWidget> {
  final ScrollController _scrollController = ScrollController();
  late int _storeId;

  @override
  void initState() {
    super.initState();
    _storeId = getIt<CacheHelper>().getData(key: CacheHelperKeys.mainStoreId);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().initNewArrivals(_storeId, widget.categoryId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentStoreId = getIt<CacheHelper>().getData(
      key: CacheHelperKeys.mainStoreId,
    );

    if (currentStoreId != _storeId) {
      _storeId = currentStoreId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<HomeCubit>().initNewArrivals(
            _storeId,
            widget.categoryId,
          );
        }
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) return;

    final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
    if (reached) {
      context.read<HomeCubit>().loadMoreNewArrivals(
        widget.categoryId,
        _storeId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final categoryId = widget.categoryId;
        final status = state.getNewArrivalsStatusForCategory(
          categoryId,
          storeId: _storeId,
        );
        final items = state.getNewArrivalsForCategory(
          categoryId,
          storeId: _storeId,
        );
        final isLoading = state.isNewArrivalsLoadingForCategory(
          categoryId,
          storeId: _storeId,
        );

        if (status == ApiStatus.success && items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("new_arrivals".tr(), style: AppTextStyle.styleBlack18Bold),
              SizedBox(height: 10.h),
              _buildContent(status, items.cast<ProductItemModel>(), isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    ApiStatus status,
    List<ProductItemModel> items,
    bool isLoading,
  ) {
    if (status == ApiStatus.loading && items.isEmpty) {
      return _buildLoadingList();
    }

    if (status == ApiStatus.error && items.isEmpty) {
      return const CustomHomeErrorWidget();
    }

    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    return SizedBox(
      height: 340.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: items.length + (isLoading ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          if (isLoading && index == items.length) {
            return const CustomCategoryDetailsLoadingCardWidget();
          }

          final item = items[index];

          final String imageUrl =
              item.keyDefaultImage?.isNotEmpty == true
                  ? ""
                  : (item.media.isNotEmpty ? item.media.first.url : '');

          final String title = isArabic ? item.nameAr : item.nameEn;
          final String subTitle =
              isArabic ? (item.subNameAr ?? '') : (item.subNameEn ?? '');

          final double priceAfterDiscount = item.discountedPrice;
          final double? oldPrice = item.hasDiscount ? item.basePrice : null;

          return CustomItemCardWidget(
            imageUrl: imageUrl,
            title: title,
            subTitle: subTitle,
            price: priceAfterDiscount,
            oldPrice: oldPrice,
            isFreeShipping: item.hasFreeShipping,
            rating: item.totalRating,
            showSubtitle: subTitle.isNotEmpty,
            showPrice: true,
            useCartLogic: true,
            productId: item.id,
            defaultQuantity: 1,
            variantId: null,
            onTap:
                () => Navigator.pushNamed(
                  context,
                  AppRoutesKeys.product,
                  arguments: {"productId": item.id},
                ),
            onAddTap: null,
          );
        },
      ),
    );
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: 250.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => const CustomCategoryDetailsLoadingCardWidget(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
