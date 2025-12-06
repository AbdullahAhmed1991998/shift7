import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_order_item_widget.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/cart_store_group_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_store_shape_widget.dart';

class CustomCheckoutOrderListWidget extends StatefulWidget {
  final ValueChanged<List<Map<String, dynamic>>>? onItemsChanged;
  const CustomCheckoutOrderListWidget({super.key, this.onItemsChanged});

  @override
  State<CustomCheckoutOrderListWidget> createState() =>
      _CustomCheckoutOrderListWidgetState();
}

class _CustomCheckoutOrderListWidgetState
    extends State<CustomCheckoutOrderListWidget> {
  int? _selectedStoreId;
  int? _selectedMarketId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().getCart();
    });
  }

  List<CartStoreGroupModel> _storesNoDup(List<CartStoreGroupModel> groups) {
    final ids = <int>{};
    final list = <CartStoreGroupModel>[];
    for (final g in groups) {
      if (ids.add(g.storeId)) list.add(g);
    }
    return list;
  }

  List<Map<String, dynamic>> _marketsForSelectedStore(
    List<CartStoreGroupModel> groups,
  ) {
    if (_selectedStoreId == null) return [];
    final ids = <int>{};
    final list = <Map<String, dynamic>>[];
    for (final g in groups) {
      if (g.storeId == _selectedStoreId &&
          g.marketId != null &&
          ids.add(g.marketId!)) {
        list.add({
          'marketId': g.marketId,
          'marketNameAr': g.marketNameAr,
          'marketNameEn': g.marketNameEn,
        });
      }
    }
    return list;
  }

  bool _showMarketsTab(List<CartStoreGroupModel> groups) {
    if (_selectedStoreId == null) return false;
    return _marketsForSelectedStore(groups).isNotEmpty;
  }

  List<CartItemModel> _filteredItems(List<CartStoreGroupModel> groups) {
    if (_selectedStoreId == null && _selectedMarketId == null) {
      return groups.expand((g) => g.items).toList();
    }
    if (_selectedStoreId != null && _selectedMarketId == null) {
      return groups
          .where((g) => g.storeId == _selectedStoreId)
          .expand((g) => g.items)
          .toList();
    }
    if (_selectedStoreId != null && _selectedMarketId != null) {
      return groups
          .where(
            (g) =>
                g.marketId == _selectedMarketId &&
                g.storeId == _selectedStoreId,
          )
          .expand((g) => g.items)
          .toList();
    }
    return [];
  }

  String _storeLabel(BuildContext context, CartStoreGroupModel g) {
    final isArabic = Localizations.localeOf(
      context,
    ).languageCode.toLowerCase().startsWith('ar');
    final ar = (g.storeNameAr).toString().trim();
    final en = (g.storeNameEn).toString().trim();
    if (isArabic) {
      return ar.isNotEmpty ? ar : (en.isNotEmpty ? en : 'Store ${g.storeId}');
    }
    return en.isNotEmpty ? en : (ar.isNotEmpty ? ar : 'Store ${g.storeId}');
  }

  String _marketLabel(BuildContext context, Map<String, dynamic> m) {
    final isArabic = Localizations.localeOf(
      context,
    ).languageCode.toLowerCase().startsWith('ar');
    final ar = (m['marketNameAr'] ?? '').toString().trim();
    final en = (m['marketNameEn'] ?? '').toString().trim();
    if (isArabic) {
      return ar.isNotEmpty
          ? ar
          : (en.isNotEmpty ? en : 'Market ${m['marketId']}');
    }
    return en.isNotEmpty
        ? en
        : (ar.isNotEmpty ? ar : 'Market ${m['marketId']}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen:
          (prev, curr) =>
              prev.getCartStatus != curr.getCartStatus ||
              prev.getCart != curr.getCart,
      builder: (context, state) {
        final List<CartStoreGroupModel> groups =
            state.getCart?.data.stores ?? const <CartStoreGroupModel>[];
        final stores = _storesNoDup(groups);
        final markets = _marketsForSelectedStore(groups);
        final hasMarkets = _showMarketsTab(groups);
        final itemsList = _filteredItems(groups);

        final mappedVisible = itemsList
            .map((item) {
              final variantId = item.variant?.id;
              final Map<String, dynamic> map = {
                'product_id': item.product.id,
                'quantity': item.quantity,
              };
              if (variantId != null && variantId > 0) {
                map['variant_id'] = variantId;
              }
              return map;
            })
            .toList(growable: false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onItemsChanged?.call(mappedVisible);
        });

        final bool isArabic = Localizations.localeOf(
          context,
        ).languageCode.toLowerCase().startsWith('ar');
        final String allLabel = isArabic ? 'الكل' : 'All';

        final MainAxisAlignment tabRowCenter = MainAxisAlignment.center;

        final int listCount =
            itemsList.isEmpty ? 0 : (itemsList.length * 2) - 1;
        final int totalCount = 1 + listCount;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 48.h,
                    child: Row(
                      mainAxisAlignment: tabRowCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: CustomCartStoreShapeWidget(
                            label: allLabel,
                            selected:
                                _selectedStoreId == null &&
                                _selectedMarketId == null,
                            backgroundColor:
                                (_selectedStoreId == null &&
                                        _selectedMarketId == null)
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                            textColor:
                                (_selectedStoreId == null &&
                                        _selectedMarketId == null)
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                            onTap:
                                () => setState(() {
                                  _selectedStoreId = null;
                                  _selectedMarketId = null;
                                }),
                          ),
                        ),
                        ...stores.map(
                          (g) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: CustomCartStoreShapeWidget(
                              label: _storeLabel(context, g),
                              selected: _selectedStoreId == g.storeId,
                              backgroundColor:
                                  _selectedStoreId == g.storeId
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                              textColor:
                                  _selectedStoreId == g.storeId
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                              onTap:
                                  () => setState(() {
                                    _selectedStoreId = g.storeId;
                                    _selectedMarketId = null;
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (hasMarkets)
                    SizedBox(
                      height: 48.h,
                      child: Row(
                        mainAxisAlignment: tabRowCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: CustomCartStoreShapeWidget(
                              label: allLabel,
                              selected: _selectedMarketId == null,
                              backgroundColor:
                                  _selectedMarketId == null
                                      ? AppColors.secondaryColor
                                      : Colors.transparent,
                              textColor:
                                  _selectedMarketId == null
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                              onTap:
                                  () => setState(() {
                                    _selectedMarketId = null;
                                  }),
                            ),
                          ),
                          ...markets.map(
                            (m) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: CustomCartStoreShapeWidget(
                                label: _marketLabel(context, m),
                                selected: _selectedMarketId == m['marketId'],
                                backgroundColor:
                                    _selectedMarketId == m['marketId']
                                        ? AppColors.secondaryColor
                                        : Colors.transparent,
                                textColor:
                                    _selectedMarketId == m['marketId']
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                onTap:
                                    () => setState(() {
                                      _selectedMarketId = m['marketId'];
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }
            final adj = index - 1;
            if (adj.isEven) {
              final i = adj ~/ 2;
              final item = itemsList[i];
              return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: CustomCheckoutOrderItemWidget(index: i, item: item),
              );
            } else {
              return SizedBox(height: 10.h);
            }
          }, childCount: totalCount),
        );
      },
    );
  }
}
