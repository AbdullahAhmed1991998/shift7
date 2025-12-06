import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_price_display.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_checkout_button.dart';

class CustomCartHeader extends StatelessWidget {
  final double totalPrice;
  const CustomCartHeader({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCartPriceDisplay(totalPrice: totalPrice),
          CustomCheckoutButton(totalPrice: totalPrice),
        ],
      ),
    );
  }
}
