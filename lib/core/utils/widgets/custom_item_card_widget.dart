import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_cached_network_image.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';

class CustomItemCardWidget extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String? subTitle;
  final double price;
  final double? oldPrice;
  final bool isFreeShipping;
  final double? rating;
  // final bool isWished;

  final bool showSubtitle;
  final bool showPrice;

  final bool useCartLogic;
  final int? productId;
  final int defaultQuantity;
  final int? variantId;

  final VoidCallback? onTap;
  final Future<void> Function()? onAddTap;

  const CustomItemCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subTitle,
    required this.price,
    this.oldPrice,
    this.isFreeShipping = false,
    this.rating,
    // this.isWished = false,
    this.showSubtitle = true,
    this.showPrice = true,
    this.useCartLogic = false,
    this.productId,
    this.defaultQuantity = 1,
    this.variantId,
    this.onTap,
    this.onAddTap,
  });

  @override
  State<CustomItemCardWidget> createState() => _CustomItemCardWidgetState();
}

class _CustomItemCardWidgetState extends State<CustomItemCardWidget>
    with SingleTickerProviderStateMixin {
  final _secure = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool _isSubmitting = false;
  // late bool _isWishedLocal;

  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    // _isWishedLocal = widget.isWished;
    _checkLoginStatus();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant CustomItemCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.isWished != widget.isWished) {
    // _isWishedLocal = widget.isWished;
    // }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final token = await _secure.read(key: 'userToken');
      if (!mounted) return;
      setState(() => _isLoggedIn = token != null && token.isNotEmpty);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoggedIn = false);
    }
  }

  Future<void> _handleAddWithCart() async {
    if (!_isLoggedIn || _isSubmitting) {
      Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
      return;
    }
    if (widget.productId == null) return;

    setState(() => _isSubmitting = true);

    await context.read<CartCubit>().addToCart(
      productId: widget.productId!,
      quantity: widget.defaultQuantity,
      variantId: widget.variantId,
    );

    if (!mounted) return;
    final state = context.read<CartCubit>().state;

    if (state.addToCartStatus == ApiStatus.success) {
      showToast(
        context,
        isSuccess: true,
        message: "addToCartSuccess".tr(),
        icon: Icons.check_circle,
      );
    } else if (state.addToCartStatus == ApiStatus.error) {
      showToast(
        context,
        isSuccess: false,
        message: state.errorMessage,
        icon: Icons.error,
      );
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleAddCustom() async {
    if (!_isLoggedIn || _isSubmitting) {
      Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
      return;
    }
    if (widget.onAddTap == null) return;

    setState(() => _isSubmitting = true);

    try {
      await widget.onAddTap!.call();
    } catch (_) {
      if (!mounted) return;
      showToast(
        context,
        isSuccess: false,
        message: 'somethingWentWrong'.tr(),
        icon: Icons.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _handleAdd() async {
    if (widget.useCartLogic) {
      await _handleAddWithCart();
    } else {
      await _handleAddCustom();
    }
  }

  // Future<void> _toggleWish() async {
  //   if (!_isLoggedIn) {
  //     Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
  //     return;
  //   }
  //   if (widget.productId == null) return;

  //   final favCubit = context.read<FavCubit>();

  //   final bool newValue = !_isWishedLocal;
  //   setState(() => _isWishedLocal = newValue);

  //   await favCubit.setFav(productId: widget.productId!);
  //   final favState = favCubit.state;

  //   if (!mounted) return;

  //   if (favState.setFavStatus == ApiStatus.error) {
  //     setState(() => _isWishedLocal = !newValue);
  //     showToast(
  //       context,
  //       isSuccess: false,
  //       message: favState.errorMessage,
  //       icon: Icons.error,
  //     );
  //   } else if (favState.setFavStatus == ApiStatus.success) {
  //     showToast(
  //       context,
  //       isSuccess: true,
  //       message: newValue ? 'addedToFav'.tr() : 'removedFromFav'.tr(),
  //       icon: Icons.favorite,
  //     );
  //   }
  // }

  Widget _buildStaticLogoFallback() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 150.h,
      child: Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(10),
            BlendMode.srcATop,
          ),
          child: SvgPicture.asset(
            AppIcons.appIcon,
            width: double.infinity,
            height: 50.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    final String priceStr = formatJod(widget.price, isArabic);
    final String? oldPriceStr =
        widget.oldPrice != null ? formatJod(widget.oldPrice, isArabic) : null;

    // final bool showFavAndBuy = _isLoggedIn;

    return BlocListener<CartCubit, CartState>(
      listenWhen: (prev, curr) => prev.addToCartStatus != curr.addToCartStatus,
      listener: (_, __) {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150.h,
                        child:
                            widget.imageUrl.isEmpty
                                ? _buildStaticLogoFallback()
                                : CustomCachedNetworkImage(
                                  imageUrl: widget.imageUrl,
                                  width: double.infinity,
                                  height: 150.h,
                                  radius: 12.r,
                                  fit: BoxFit.contain,
                                ),
                      ),

                      // if (showFavAndBuy)
                      //   Positioned(
                      //     top: 8.w,
                      //     right: 8.w,
                      //     child: GestureDetector(
                      //       onTap: _toggleWish,
                      //       behavior: HitTestBehavior.opaque,
                      //       child: Container(
                      //         width: 32.w,
                      //         height: 32.w,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white.withAlpha(217),
                      //           shape: BoxShape.circle,
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black.withAlpha(12),
                      //               blurRadius: 6,
                      //               offset: const Offset(0, 2),
                      //             ),
                      //           ],
                      //         ),
                      //         alignment: Alignment.center,
                      //         child: Icon(
                      //           _isWishedLocal
                      //               ? Icons.favorite
                      //               : Icons.favorite_border,
                      //           color:
                      //               _isWishedLocal
                      //                   ? Colors.red
                      //                   : Colors.grey[500],
                      //           size: 18.w,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      if (widget.rating != null)
                        Positioned(
                          top: 8.w,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(153),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  widget.rating!.toStringAsFixed(1),
                                  style: AppTextStyle.styleBlack12W500.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.title,
                    style: AppTextStyle.styleBlack16W500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.showSubtitle &&
                      (widget.subTitle?.isNotEmpty ?? false)) ...[
                    SizedBox(height: 4.h),
                    Text(
                      widget.subTitle!,
                      style: AppTextStyle.styleBlack14W500.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (widget.showPrice) ...[
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            priceStr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.stylePrimary16Bold,
                          ),
                        ),
                        if (oldPriceStr != null &&
                            widget.oldPrice! > widget.price) ...[
                          SizedBox(width: 6.w),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              oldPriceStr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.styleBlack14W500.copyWith(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  SizedBox(height: 6.h),
                  widget.isFreeShipping == false
                      ? const SizedBox.shrink()
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 16.w,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              'freeDelivery'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.styleBlack12W500.copyWith(
                                color:
                                    widget.isFreeShipping
                                        ? AppColors.primaryColor
                                        : Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                  widget.isFreeShipping == false
                      ? SizedBox(height: 15.h)
                      : SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child:
                          _isSubmitting
                              ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                'buyNow'.tr(),
                                style: AppTextStyle.styleBlack16W500.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
