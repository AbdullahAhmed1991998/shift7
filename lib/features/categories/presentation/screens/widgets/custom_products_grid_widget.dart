import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/categories/presentation/screens/widgets/custom_category_details_item_card_widget.dart';

class CustomProductsGridWidget extends StatelessWidget {
  final List<ProductItemModel> products;
  const CustomProductsGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 160.w / 250.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.product,
                arguments: {"productId": products[index].id},
              );
            },
            child: CustomCategoryDetailsItemCardWidget(
              product: products[index],
            ),
          ),
          childCount: products.length,
        ),
      ),
    );
  }
}
