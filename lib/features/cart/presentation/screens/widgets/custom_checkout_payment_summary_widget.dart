import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/cart_store_summary_model.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_payment_item_row_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCheckoutPaymentSummaryWidget extends StatefulWidget {
  final int? addressId;
  final String? coupon;
  final List<Map<String, dynamic>> items;
  final String totalPrice;

  const CustomCheckoutPaymentSummaryWidget({
    super.key,
    required this.addressId,
    required this.coupon,
    required this.items,
    required this.totalPrice,
  });

  @override
  State<CustomCheckoutPaymentSummaryWidget> createState() =>
      _CustomCheckoutPaymentSummaryWidgetState();
}

class _CustomCheckoutPaymentSummaryWidgetState
    extends State<CustomCheckoutPaymentSummaryWidget> {
  bool _expanded = false;
  String _lastSig = '';

  List<CheckoutCartItemModel> _toCheckoutModels(
    List<Map<String, dynamic>> maps,
  ) {
    return maps
        .map((m) {
          final int? variantId = m['variant_id'];

          if (variantId == 0) {
            return CheckoutCartItemModel(
              productId: m['product_id'] as int,
              variantId: null,
              quantity: m['quantity'] as int,
            );
          } else {
            return CheckoutCartItemModel(
              productId: m['product_id'] as int,
              variantId: variantId,
              quantity: m['quantity'] as int,
            );
          }
        })
        .toList(growable: false);
  }

  String _signature() {
    final sb = StringBuffer();
    sb.write(widget.addressId?.toString() ?? '');
    sb.write('|');
    sb.write((widget.coupon?.trim() ?? '').toUpperCase());
    sb.write('|');
    for (final m in widget.items) {
      final p = m['product_id'];
      final v = m['variant_id'];
      final q = m['quantity'];
      sb.write('$p-$v-$q|');
    }
    return sb.toString();
  }

  void _requestBill(BuildContext context) {
    final items = _toCheckoutModels(widget.items);
    context.read<CartCubit>().getCartDetails(
      addressId: widget.addressId,
      coupon:
          (widget.coupon?.trim().isEmpty ?? true)
              ? null
              : widget.coupon!.trim(),
      cartItems: items,
    );
    _lastSig = _signature();
  }

  void _maybeRefreshBill(BuildContext context, CartState state) {
    if (!_expanded) return;
    if (state.getCartDetailsStatus == ApiStatus.loading) return;
    final sig = _signature();
    if (sig != _lastSig) {
      _requestBill(context);
    }
  }

  void _checkout(BuildContext context) {
    final items = _toCheckoutModels(widget.items);
    context.read<CartCubit>().checkout(
      addressId: widget.addressId,
      coupon:
          (widget.coupon?.trim().isNotEmpty ?? false)
              ? widget.coupon!.trim()
              : null,
      items: items,
    );
  }

  @override
  void didUpdateWidget(covariant CustomCheckoutPaymentSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final state = context.read<CartCubit>().state;
    _maybeRefreshBill(context, state);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';

    return SliverToBoxAdapter(
      child: BlocConsumer<CartCubit, CartState>(
        listenWhen:
            (p, c) =>
                p.checkoutStatus != c.checkoutStatus ||
                p.errorMessage != c.errorMessage,
        listener: (context, state) {
          if (state.checkoutStatus == ApiStatus.success) {
            showToast(
              context,
              isSuccess: true,
              message: 'orderPlacedSuccess'.tr(),
              icon: Icons.check,
            );
            Navigator.pushReplacementNamed(
              context,
              AppRoutesKeys.shift7MainApp,
              arguments: {
                "storeId": getIt<CacheHelper>().getData(
                  key: CacheHelperKeys.mainStoreId,
                ),
              },
            );
          } else if (state.checkoutStatus == ApiStatus.error) {
            showToast(
              context,
              isSuccess: false,
              message: 'checkoutFailed'.tr(),
              icon: Icons.error,
            );
          }
        },
        builder: (context, state) {
          if (!_expanded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomAppBottom(
                height: 50.h,
                backgroundColor: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  setState(() => _expanded = true);
                  _requestBill(context);
                },
                child: Text(
                  'viewYourBill'.tr(),
                  style: AppTextStyle.styleBlack18Bold.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            );
          }

          _maybeRefreshBill(context, state);

          final loading = state.getCartDetailsStatus == ApiStatus.loading;
          final success = state.getCartDetailsStatus == ApiStatus.success;

          double sumOrderWithoutTax = 0.0;
          double sumOrderTax = 0.0;
          double sumDeliveryFee = 0.0;
          double sumTotal = 0.0;
          double singleCoupon = 0.0;
          double sumDiscounts = 0.0;
          double sumServiceFees = 0.0;

          bool anyNotAvailable = false;
          bool anyFree = false;
          bool anyAvailable = false;

          String? firstAvailableTime;
          String? firstFreeTime;

          if (success) {
            final List<CartStoreSummaryModel> stores =
                state.getCartDetailsModel?.data ??
                const <CartStoreSummaryModel>[];

            if (stores.isNotEmpty) {
              singleCoupon = (stores.first.coupon ?? 0.0);
            }

            for (final s in stores) {
              sumOrderWithoutTax += (s.orderWithoutTax ?? 0.0);
              sumOrderTax += (s.orderTax ?? 0.0);
              sumDeliveryFee += (s.deliveryFee ?? 0.0);
              sumTotal += (s.total ?? 0.0);
              sumDiscounts += (s.totalDiscountsFees ?? 0.0);
              sumServiceFees += (s.totalServiceFees ?? 0.0);

              final status = s.deliveryStatus?.toLowerCase();
              final time = s.deliveryTime?.trim() ?? '';

              if (status == 'not_available') {
                anyNotAvailable = true;
              } else if (status == 'free') {
                anyFree = true;
                firstFreeTime ??= time.isNotEmpty ? time : null;
              } else if (status == 'available') {
                anyAvailable = true;
                firstAvailableTime ??= time.isNotEmpty ? time : null;
              }
            }
          }

          String deliveryStr;
          String deliveryTimeStr;

          if (loading) {
            deliveryStr = '—';
            deliveryTimeStr = '—';
          } else {
            if (anyAvailable) {
              deliveryStr = formatJod(sumDeliveryFee, isArabic);
              deliveryTimeStr =
                  (firstAvailableTime != null && firstAvailableTime.isNotEmpty)
                      ? firstAvailableTime
                      : '—';
            } else if (anyFree) {
              deliveryStr = 'freeDelivery'.tr();
              deliveryTimeStr =
                  (firstFreeTime != null && firstFreeTime.isNotEmpty)
                      ? firstFreeTime
                      : '—';
            } else if (!anyAvailable && !anyFree) {
              deliveryStr = 'noShipping'.tr();
              deliveryTimeStr = 'noShipping'.tr();
            } else {
              deliveryStr = formatJod(sumDeliveryFee, isArabic);
              deliveryTimeStr = '—';
            }
          }

          final orderWithoutTaxStr =
              loading ? '—' : formatJod(sumOrderWithoutTax, isArabic);
          final orderTaxStr = loading ? '—' : formatJod(sumOrderTax, isArabic);
          final couponStr = loading ? '—' : formatJod(singleCoupon, isArabic);
          final discountStr = loading ? '—' : formatJod(sumDiscounts, isArabic);
          final serviceFeesStr =
              loading ? '—' : formatJod(sumServiceFees, isArabic);
          final totalStr = loading ? '—' : formatJod(sumTotal, isArabic);

          return Card(
            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!loading && anyNotAvailable)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withAlpha(80),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'noShippingForTheseProducts'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'orderWithoutTax'.tr(),
                    value: orderWithoutTaxStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'orderTax'.tr(),
                    value: orderTaxStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'coupon'.tr(),
                    value:
                        (!loading && (singleCoupon == 0.0))
                            ? 'noCoupon'.tr()
                            : couponStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'discounts'.tr(),
                    value: discountStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'serviceFees'.tr(),
                    value: serviceFeesStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'delivery'.tr(),
                    value: deliveryStr,
                  ),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'deliveryTime'.tr(),
                    value: deliveryTimeStr,
                  ),
                  SizedBox(height: 10.h),
                  CustomDashedDivider(
                    color: Colors.grey[300]!,
                    thickness: 1.h,
                    height: 1.h,
                  ),
                  SizedBox(height: 10.h),
                  CustomCheckoutPaymentItemRowWidget(
                    label: 'total'.tr(),
                    value: totalStr,
                    isTotal: true,
                  ),
                  SizedBox(height: 20.h),
                  CustomAppBottom(
                    height: 50.h,
                    verticalPadding: 12.5.h,
                    horizontalPadding: 40.w,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    onTap:
                        state.checkoutStatus == ApiStatus.loading
                            ? null
                            : () => _checkout(context),
                    child:
                        state.checkoutStatus == ApiStatus.loading
                            ? SizedBox(
                              width: 22,
                              height: 22,
                              child: Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColors.secondaryColor,
                                  size: 30.sp,
                                ),
                              ),
                            )
                            : Text(
                              'checkout'.tr(),
                              style: AppTextStyle.styleBlack16Bold.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
