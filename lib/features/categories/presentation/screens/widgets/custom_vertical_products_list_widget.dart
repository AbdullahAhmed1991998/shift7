import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_item_card_widget.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_loading_card_widget.dart';

class CustomVerticalProductsListWidget extends StatelessWidget {
  final List<dynamic> products;
  final bool loadingMore;

  const CustomVerticalProductsListWidget({
    super.key,
    required this.products,
    required this.loadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: products.length + (loadingMore ? 2 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 160.w / 250.h,
      ),
      itemBuilder: (context, index) {
        if (loadingMore && index >= products.length) {
          return const CustomCategoryDetailsLoadingCardWidget();
        }
        final product = products[index];
        return CustomCategoryDetailsItemCardWidget(product: product);
      },
    );
  }
}
