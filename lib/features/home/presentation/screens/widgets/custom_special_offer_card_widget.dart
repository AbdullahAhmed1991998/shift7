import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_cached_network_image.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';

class CustomSpecialOfferCardWidget extends StatefulWidget {
  final ProductItemModel item;
  const CustomSpecialOfferCardWidget({super.key, required this.item});

  @override
  State<CustomSpecialOfferCardWidget> createState() =>
      _CustomSpecialOfferCardWidgetState();
}

class _CustomSpecialOfferCardWidgetState
    extends State<CustomSpecialOfferCardWidget> {
  final _secure = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool _isSubmitting = false;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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

  bool get _hasVariants {
    try {
      final dynamic hv = (widget.item as dynamic).hasVariants;
      if (hv is bool) return hv;
    } catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    final String imageUrl =
        widget.item.media.isNotEmpty ? widget.item.media[0].url : '';

    final bool showAddCircle = _isLoggedIn && !_hasVariants && !_added;
    return BlocListener<CartCubit, CartState>(
      listenWhen: (prev, curr) => prev.addToCartStatus != curr.addToCartStatus,
      listener: (context, state) {
        if (!_isSubmitting) return;
        if (state.addToCartStatus == ApiStatus.success) {
          showToast(
            context,
            isSuccess: true,
            message: "addToCartSuccess".tr(),
            icon: Icons.check_circle,
          );
          setState(() {
            _added = true;
            _isSubmitting = false;
          });
        } else if (state.addToCartStatus == ApiStatus.error) {
          showToast(
            context,
            isSuccess: false,
            message: state.errorMessage,
            icon: Icons.error,
          );
          setState(() => _isSubmitting = false);
        }
      },
      child: SizedBox(
        width: 160.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 160.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomCachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 160.h,
                    width: 160.w,
                    radius: 12.r,
                  ),
                ),

                if (showAddCircle || _isSubmitting || _added)
                  _added
                      ? SizedBox.shrink()
                      : Positioned(
                        bottom: 8.w,
                        right: 8.w,
                        child: GestureDetector(
                          onTap:
                              (showAddCircle && !_isSubmitting)
                                  ? () {
                                    setState(() => _isSubmitting = true);
                                    context.read<CartCubit>().addToCart(
                                      productId: widget.item.id,
                                      quantity: 1,
                                      variantId: null,
                                    );
                                  }
                                  : null,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(8),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child:
                                _isSubmitting
                                    ? SizedBox(
                                      width: 18.w,
                                      height: 18.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                    : Icon(
                                      Icons.add_shopping_cart_rounded,
                                      color: AppColors.primaryColor,
                                      size: 22.w,
                                    ),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              isArabic
                  ? widget.item.nameAr
                  : widget.item.nameEn.englishTitleCase(),
              style: AppTextStyle.styleBlack16W500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              isArabic
                  ? (widget.item.subNameAr ?? "")
                  : (widget.item.subNameEn ?? ""),
              style: AppTextStyle.styleBlack14W500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              formatJod(widget.item.basePrice, isArabic),
              style: AppTextStyle.stylePrimary16Bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
