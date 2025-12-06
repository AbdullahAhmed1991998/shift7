import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_item_card_widget.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';

class CustomHorizontalProductsWidget extends StatelessWidget {
  final List<dynamic> products;
  final bool loadingMore;

  const CustomHorizontalProductsWidget({
    super.key,
    required this.products,
    required this.loadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: products.length + (loadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          if (loadingMore && index == products.length) {
            return const CustomCategoryDetailsLoadingCardWidget();
          }
          final product = products[index];
          return GestureDetector(
            onTap:
                () => Navigator.pushNamed(
                  context,
                  AppRoutesKeys.product,
                  arguments: {"productId": product.id},
                ),
            child: CustomCategoryDetailsItemCardWidget(product: product),
          );
        },
      ),
    );
  }
}
