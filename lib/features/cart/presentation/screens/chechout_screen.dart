import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_order_list_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_payment_summary_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_promo_code_input_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_section_title_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_current_location_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPrice;
  const CheckoutScreen({super.key, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _promoCodeController = TextEditingController();

  int? _addressId;
  List<Map<String, dynamic>> _checkoutItems = const [];

  String? _coupon;

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

  void _applyCouponAndRefresh() {
    final items = _toCheckoutModels(_checkoutItems);
    context.read<CartCubit>().getCartDetails(
      addressId: _addressId,
      coupon: (_coupon?.trim().isEmpty ?? true) ? null : _coupon!.trim(),
      cartItems: items,
    );
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: 'checkout'.tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          CustomCheckoutSectionTitleWidget(
            title: 'yourAddress'.tr(),
            hasLastText: true,
            lastText: 'addLocation'.tr(),
            onLastTextTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.addLocation,
                arguments: {'isCart': true},
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: CustomCurrentLocationWidget(
              onSelectedAddressId: (id) => setState(() => _addressId = id),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: CustomDashedDivider(
              color: Colors.grey[300]!,
              thickness: 1.h,
              height: 1.h,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),

          CustomCheckoutOrderListWidget(
            onItemsChanged: (maps) => setState(() => _checkoutItems = maps),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: CustomDashedDivider(
              color: Colors.grey[300]!,
              thickness: 1.h,
              height: 1.h,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          CustomCheckoutPromoCodeInputWidget(
            controller: _promoCodeController,
            onChanged: (v) => setState(() => _coupon = v),
            onApply: _applyCouponAndRefresh,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: CustomDashedDivider(
              color: Colors.grey[300]!,
              thickness: 1.h,
              height: 1.h,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),

          CustomCheckoutPaymentSummaryWidget(
            addressId: _addressId,
            coupon: _coupon?.trim().isEmpty == true ? null : _coupon?.trim(),
            items: _checkoutItems,
            totalPrice: widget.totalPrice.toString(),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ],
      ),
    );
  }
}
