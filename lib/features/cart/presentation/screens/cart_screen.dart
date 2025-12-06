import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_header.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_store_shape_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/cart_store_group_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_list_view_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  bool _isLoggedIn = false;
  List<CartStoreGroupModel> _groups = [];
  List<CartItemModel> _items = [];
  int? _selectedStoreId;
  int? _selectedMarketId;
  final List<int> _localQty = [];
  final Set<int> _dirtyIndices = <int>{};
  final Set<int> _updatingIndices = <int>{};
  int? _lastRequestedIndex;
  String? _lastToastMessage;
  DateTime? _lastToastTime;
  final Duration _toastDebounceTime = const Duration(milliseconds: 1200);

  List<CartStoreGroupModel> get _storesNoDup {
    final ids = <int>{};
    final list = <CartStoreGroupModel>[];
    for (final g in _groups) {
      if (ids.add(g.storeId)) list.add(g);
    }
    return list;
  }

  List<Map<String, dynamic>> _marketsForSelectedStore() {
    if (_selectedStoreId == null) return [];
    final ids = <int>{};
    final list = <Map<String, dynamic>>[];
    for (final g in _groups) {
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

  bool get _showMarketsTab {
    if (_selectedStoreId == null) return false;
    return _marketsForSelectedStore().isNotEmpty;
  }

  List<CartItemModel> _filteredItems() {
    if (_selectedStoreId == null && _selectedMarketId == null) {
      return _groups.expand((g) => g.items).toList();
    }
    if (_selectedStoreId != null && _selectedMarketId == null) {
      return _groups
          .where((g) => g.storeId == _selectedStoreId)
          .expand((g) => g.items)
          .toList();
    }
    if (_selectedStoreId != null && _selectedMarketId != null) {
      return _groups
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

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetch();
  }

  Future<void> _checkTokenAndFetch() async {
    final token = await _secureStorage.read(key: userToken);
    _isLoggedIn = token != null && token.isNotEmpty;
    if (_isLoggedIn) {
      // ignore: use_build_context_synchronously
      final cubit = context.read<CartCubit>();
      await cubit.getCart();
      _groups = List<CartStoreGroupModel>.from(
        cubit.state.getCart?.data.stores ?? const <CartStoreGroupModel>[],
      );
      _items = _filteredItems();
      _localQty.clear();
      _localQty.addAll(_items.map((it) => it.quantity));
      _selectedStoreId = null;
      _selectedMarketId = null;
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  double _computeTotal() {
    double total = 0.0;
    for (var i = 0; i < _items.length; i++) {
      final it = _items[i];
      final unitStr =
          it.variantId == null ? it.product.basePrice : it.variant?.price;
      final unit = double.tryParse(unitStr.toString()) ?? 0.0;

      final double discountPerUnit = it.product.totalDiscountsValue;
      final bool hasDiscount = discountPerUnit > 0;
      double effectiveUnit = unit;
      if (hasDiscount) {
        final double perUnitAfterDiscount = unit - discountPerUnit;
        effectiveUnit = perUnitAfterDiscount < 0 ? 0 : perUnitAfterDiscount;
      }

      final qty = _localQty[i];
      total += effectiveUnit * qty;
    }
    return total;
  }

  void _onChangeQuantity(int index, int newQty) {
    if (index < 0 || index >= _items.length) return;
    setState(() {
      _localQty[index] = newQty;
      _dirtyIndices.add(index);
    });
  }

  Future<void> _onDeleteItem(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    final variantId = item.variant?.id;
    final cubit = context.read<CartCubit>();
    if (variantId == null || variantId == 0) {
      await cubit.removeFromCart(productId: item.product.id);
    } else {
      await cubit.removeFromCart(
        productId: item.product.id,
        variantId: variantId,
      );
    }
    final removeStatus = cubit.state.removeFromCartStatus;
    if (removeStatus == ApiStatus.success) {
      await cubit.getCart();
      if (!mounted) return;
      setState(() {
        _groups = List<CartStoreGroupModel>.from(
          cubit.state.getCart?.data.stores ?? const <CartStoreGroupModel>[],
        );
        _items = _filteredItems();
        _localQty
          ..clear()
          ..addAll(_items.map((it) => it.quantity));
        _dirtyIndices.clear();
        _updatingIndices.clear();
        _lastRequestedIndex = null;
      });
      _showDebouncedToast(
        context: context,
        isSuccess: true,
        message: "itemRemovedSuccessfully".tr(),
        icon: Icons.check,
      );
    } else {
      _showDebouncedToast(
        // ignore: use_build_context_synchronously
        context: context,
        isSuccess: false,
        message: "failedToRemove".tr(),
        icon: Icons.error,
      );
    }
  }

  Future<void> _onClearCart() async {
    await context.read<CartCubit>().clearCart();
    // ignore: use_build_context_synchronously
    final status = context.read<CartCubit>().state.clearCartStatus;
    if (status == ApiStatus.success) {
      setState(() {
        _items.clear();
        _localQty.clear();
        _dirtyIndices.clear();
        _updatingIndices.clear();
        _lastRequestedIndex = null;
        _groups.clear();
        _selectedStoreId = null;
        _selectedMarketId = null;
      });
      _showDebouncedToast(
        // ignore: use_build_context_synchronously
        context: context,
        isSuccess: true,
        message: "cartCleared".tr(),
        icon: Icons.check,
      );
    } else {
      _showDebouncedToast(
        // ignore: use_build_context_synchronously
        context: context,
        isSuccess: false,
        message: "failedToClearCart".tr(),
        icon: Icons.error,
      );
    }
  }

  Future<void> _retry() async {
    setState(() => _isLoading = true);
    await _checkTokenAndFetch();
  }

  void _showDebouncedToast({
    required BuildContext context,
    required bool isSuccess,
    required String message,
    required IconData icon,
  }) {
    final now = DateTime.now();
    if (_lastToastMessage == message &&
        _lastToastTime != null &&
        now.difference(_lastToastTime!) < _toastDebounceTime) {
      return;
    }
    _lastToastMessage = message;
    _lastToastTime = now;
    showToast(context, isSuccess: isSuccess, message: message, icon: icon);
  }

  String _storeLabel(CartStoreGroupModel g) {
    final isArabic = Localizations.localeOf(
      context,
    ).languageCode.toLowerCase().startsWith('ar');
    final ar = g.storeNameAr.trim();
    final en = g.storeNameEn.trim();
    if (isArabic) {
      return ar.isNotEmpty ? ar : (en.isNotEmpty ? en : 'Store ${g.storeId}');
    }
    return en.isNotEmpty ? en : (ar.isNotEmpty ? ar : 'Store ${g.storeId}');
  }

  String _marketLabel(Map<String, dynamic> m) {
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Center(child: NotLoggedInWidget(resourceName: "cartTitle".tr())),
      );
    }

    final stores = _storesNoDup;
    final markets = _marketsForSelectedStore();
    final hasMarkets = _showMarketsTab;
    final tabRowCenter = MainAxisAlignment.center;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (previous, current) {
          if (_lastRequestedIndex != null) {
            return previous.updateCartProductStatus !=
                    current.updateCartProductStatus &&
                current.updateCartProductStatus != ApiStatus.loading;
          }
          return false;
        },
        listener: (context, state) {
          if (_lastRequestedIndex != null) {
            final idx = _lastRequestedIndex!;
            if (state.updateCartProductStatus == ApiStatus.success) {
              setState(() {
                _updatingIndices.remove(idx);
                _dirtyIndices.remove(idx);
                _lastRequestedIndex = null;
              });
              _showDebouncedToast(
                context: context,
                isSuccess: true,
                message: "cartItemUpdated".tr(),
                icon: Icons.check,
              );
            } else if (state.updateCartProductStatus == ApiStatus.error) {
              setState(() {
                _updatingIndices.remove(idx);
                _lastRequestedIndex = null;
              });
              _showDebouncedToast(
                context: context,
                isSuccess: false,
                message: "updateFailed".tr(),
                icon: Icons.error,
              );
            }
          }
        },
        builder: (context, state) {
          if (state.getCartStatus == ApiStatus.error) {
            return Center(child: CustomHomeErrorWidget(onRetry: _retry));
          }
          if (_filteredItems().isEmpty) {
            return Center(
              child: CustomEmptyWidget(message: "yourCartIsEmpty".tr()),
            );
          }
          _items = _filteredItems();
          if (_localQty.length != _items.length) {
            _localQty.clear();
            _localQty.addAll(_items.map((it) => it.quantity));
          }
          final totalPrice = _computeTotal();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCartHeader(totalPrice: totalPrice),
              CustomDashedDivider(
                color: Colors.grey[300]!,
                thickness: 1.h,
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: CustomAppBottom(
                  height: 50.h,
                  width: double.infinity,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                  horizontalPadding: 20.w,
                  verticalPadding: 5.h,
                  onTap: _onClearCart,
                  child: Text(
                    "clearAll".tr(),
                    style: AppTextStyle.styleWhite18Bold,
                  ),
                ),
              ),
              SizedBox(
                height: 56.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: tabRowCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: CustomCartStoreShapeWidget(
                          label:
                              getIt<CacheHelper>().getData(key: 'language') ==
                                      'ar'
                                  ? 'الكل'
                                  : 'All',
                          selected:
                              _selectedStoreId == null &&
                              _selectedMarketId == null,
                          backgroundColor:
                              (_selectedStoreId == null &&
                                      _selectedMarketId == null)
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                          textColor:
                              (_selectedStoreId == null &&
                                      _selectedMarketId == null)
                                  ? AppColors.whiteColor
                                  : Colors.black,
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
                            label: _storeLabel(g),
                            selected: _selectedStoreId == g.storeId,
                            backgroundColor:
                                _selectedStoreId == g.storeId
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                            textColor:
                                _selectedStoreId == g.storeId
                                    ? AppColors.whiteColor
                                    : Colors.black,
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
              ),
              if (hasMarkets)
                SizedBox(
                  height: 56.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: tabRowCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: CustomCartStoreShapeWidget(
                            label:
                                getIt<CacheHelper>().getData(key: 'language') ==
                                        'ar'
                                    ? 'الكل'
                                    : 'All',
                            selected: _selectedMarketId == null,
                            backgroundColor:
                                _selectedMarketId == null
                                    ? AppColors.secondaryColor
                                    : Colors.transparent,
                            textColor:
                                _selectedMarketId == null
                                    ? AppColors.whiteColor
                                    : Colors.black,
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
                              label: _marketLabel(m),
                              selected: _selectedMarketId == m['marketId'],
                              backgroundColor:
                                  _selectedMarketId == m['marketId']
                                      ? AppColors.secondaryColor
                                      : Colors.transparent,
                              textColor:
                                  _selectedMarketId == m['marketId']
                                      ? AppColors.whiteColor
                                      : Colors.black,
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
                ),
              SizedBox(height: 12.h),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: CustomScrollView(
                    key: ValueKey(
                      '${_selectedStoreId ?? -1}-${_selectedMarketId ?? -1}',
                    ),
                    controller: _scrollController,
                    slivers: [
                      if (_items.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Center(
                              child: Text(
                                "yourCartIsEmpty".tr(),
                                style: AppTextStyle.styleBlack16W500,
                              ),
                            ),
                          ),
                        )
                      else
                        CustomCartListViewWidget(
                          visibleIndices: List.generate(
                            _items.length,
                            (i) => i,
                          ),
                          items: _items,
                          localQuantities: _localQty,
                          dirtyIndices: _dirtyIndices,
                          updatingIndices: _updatingIndices,
                          isAnyUpdating: _updatingIndices.isNotEmpty,
                          onChangeQuantity: _onChangeQuantity,
                          onUpdateItem: (i) async {
                            if (i < 0 || i >= _items.length) return;
                            final item = _items[i];
                            final newQty = _localQty[i];
                            final variantId = item.variant?.id;
                            if (variantId == null || variantId == 0) {
                              await context.read<CartCubit>().updateCartProduct(
                                productId: item.product.id,
                                quantity: newQty,
                              );
                            } else {
                              await context.read<CartCubit>().updateCartProduct(
                                productId: item.product.id,
                                quantity: newQty,
                                variantId: variantId,
                              );
                            }
                            setState(() {
                              _updatingIndices.add(i);
                              _lastRequestedIndex = i;
                            });
                          },
                          onDelete: _onDeleteItem,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
