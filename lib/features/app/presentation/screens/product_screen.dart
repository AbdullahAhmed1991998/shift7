import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'widgets/custom_product_bottom_bar_widget.dart';
import 'widgets/custom_product_details_widget.dart';
import 'widgets/custom_product_header_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _currentImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  double _selectedPrice = 0.0;
  int? _selectedVariantId;
  bool _didInitSelection = false;
  int _quantity = 1;
  final _secure = const FlutterSecureStorage();
  bool _isLoggedIn = false;

  List<String> _getColorNames(IntroState state) {
    final list =
        state.productDetails?.data.variantsDetails.attributes['color'] ?? [];
    return list.map((e) => e.valueEn).toList();
  }

  List<String> _getSizesForColor(IntroState state, String colorEn) {
    final combos =
        state.productDetails?.data.variantsDetails.combinations ?? [];
    final sizes = <String>[];
    for (final c in combos) {
      if ((c.color).toLowerCase() == colorEn.toLowerCase()) {
        sizes.add(c.size);
      }
    }
    final seen = <String>{};
    return sizes.where((s) => seen.add(s)).toList();
  }

  ({double price, int? variantId}) _getPriceFor(
    IntroState state, {
    required String colorEn,
    required String sizeEn,
  }) {
    final combos =
        state.productDetails?.data.variantsDetails.combinations ?? [];
    for (final c in combos) {
      final cColor = (c.color).toLowerCase();
      final cSize = (c.size).toLowerCase();
      if (cColor == colorEn.toLowerCase() && cSize == sizeEn.toLowerCase()) {
        final p = double.tryParse(c.price.toString()) ?? 0.0;
        return (price: p, variantId: c.variantId);
      }
    }
    return (price: 0.0, variantId: null);
  }

  void _initDefaultSelectionOnce(IntroState state) {
    if (_didInitSelection) return;
    final colors = _getColorNames(state);
    if (colors.isEmpty) return;

    final firstColor = colors.first;
    final sizes = _getSizesForColor(state, firstColor);
    String? firstSize = sizes.isNotEmpty ? sizes.first : null;

    double price = 0.0;
    int? vId;
    if (firstSize != null) {
      final res = _getPriceFor(state, colorEn: firstColor, sizeEn: firstSize);
      price = res.price;
      vId = res.variantId;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedColor = firstColor;
        _selectedSize = firstSize;
        _selectedPrice = price;
        _selectedVariantId = vId;
        _didInitSelection = true;
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    try {
      final token = await _secure.read(key: 'userToken');
      _isLoggedIn = token != null && token.isNotEmpty;
    } catch (_) {
      _isLoggedIn = false;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<IntroCubit>().getProductDetails(productId: widget.productId);
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<IntroCubit, IntroState>(
          builder: (context, state) {
            if (state.productStatus == ApiStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (state.productStatus == ApiStatus.error) {
              return const Center(child: CustomHomeErrorWidget());
            }
            if (state.productStatus == ApiStatus.success &&
                state.productDetails == null) {
              return Center(
                child: CustomEmptyWidget(message: "emptyProductDetails".tr()),
              );
            }
            if (state.productStatus == ApiStatus.success &&
                state.productDetails != null) {
              final details = state.productDetails!;
              final images =
                  details.data.product.media
                      .map((e) => e.url)
                      .where((u) => u.isNotEmpty)
                      .toList();

              final colors = _getColorNames(state);

              _initDefaultSelectionOnce(state);

              final sizes =
                  (_selectedColor != null)
                      ? _getSizesForColor(state, _selectedColor!)
                      : <String>[];

              final displayPrice =
                  (_selectedPrice > 0.0)
                      ? _selectedPrice
                      : double.tryParse(
                            details.data.product.basePrice.toString(),
                          ) ??
                          0.0;

              return BlocConsumer<CartCubit, CartState>(
                listener: (context, cartState) {
                  if (cartState.addToCartStatus == ApiStatus.success) {
                    return showToast(
                      context,
                      isSuccess: true,
                      message: "addToCartSuccess".tr(),
                      icon: Icons.check_circle,
                    );
                  } else if (cartState.addToCartStatus == ApiStatus.error) {
                    return showToast(
                      context,
                      isSuccess: false,
                      message: cartState.errorMessage,
                      icon: Icons.error,
                    );
                  }
                },
                builder: (context, cartState) {
                  final isAdding =
                      cartState.addToCartStatus == ApiStatus.loading;

                  return Column(
                    children: [
                      CustomProductHeaderWidget(
                        images: images,
                        productName:
                            isArabic
                                ? details.data.product.nameAr
                                : details.data.product.nameEn,
                        isFav: details.data.product.isWished,
                        productId: details.data.product.id,
                        currentIndex: _currentImageIndex,
                        onPageChanged:
                            (i) => setState(() => _currentImageIndex = i),
                        subtitle:
                            isArabic
                                ? details.data.product.subNameAr ?? ""
                                : details.data.product.subNameEn ?? "",
                      ),

                      Expanded(
                        child: CustomProductDetailsWidget(
                          isFreeShipping: details.data.product.hasFreeShipping,
                          rate: details.data.product.totalRating ?? 0,
                          description:
                              isArabic
                                  ? details.data.product.descriptionAr ?? ''
                                  : details.data.product.descriptionEn ?? '',
                          colors: colors,
                          selectedColor: _selectedColor,
                          onColorSelected: (color) {
                            final newSizes = _getSizesForColor(state, color);
                            String? newSize =
                                newSizes.isNotEmpty ? newSizes.first : null;
                            double newPrice = 0.0;
                            int? vId;
                            if (newSize != null) {
                              final res = _getPriceFor(
                                state,
                                colorEn: color,
                                sizeEn: newSize,
                              );
                              newPrice = res.price;
                              vId = res.variantId;
                            }
                            setState(() {
                              _selectedColor = color;
                              _selectedSize = newSize;
                              _selectedPrice = newPrice;
                              _selectedVariantId = vId;
                            });
                          },
                          sizes: sizes,
                          selectedSize: _selectedSize,
                          onSizeSelected: (size) {
                            if (_selectedColor == null) return;
                            final res = _getPriceFor(
                              state,
                              colorEn: _selectedColor!,
                              sizeEn: size,
                            );
                            setState(() {
                              _selectedSize = size;
                              _selectedPrice = res.price;
                              _selectedVariantId = res.variantId;
                            });
                          },
                          quantity: _quantity,
                          onQuantityChanged:
                              (q) => setState(() => _quantity = q),
                          sizesKey: ValueKey(_selectedColor),
                          reviews: details.data.product.reviews,
                          productId: details.data.product.id,
                        ),
                      ),

                      if (isAdding)
                        Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColors.secondaryColor,
                            size: 40.sp,
                          ),
                        )
                      else
                        CustomProductBottomBarWidget(
                          isStockAvailable:
                              state
                                  .productDetails!
                                  .data
                                  .product
                                  .isStockAvailable ??
                              0,
                          isLoggedIn: _isLoggedIn,
                          onLogin:
                              () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutesKeys.auth),
                          basePrice: displayPrice,
                          discountedPrice: details.data.product.discountedPrice,
                          hasDiscount: details.data.product.discountedPrice > 0,
                          onAddToCart: () {
                            final cart = context.read<CartCubit>();
                            if (_selectedVariantId == null) {
                              cart.addToCart(
                                productId: details.data.product.id,
                                quantity: _quantity,
                              );
                            } else {
                              cart.addToCart(
                                productId: details.data.product.id,
                                quantity: _quantity,
                                variantId: _selectedVariantId!,
                              );
                            }
                          },
                        ),
                      SizedBox(height: 6.h),
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
