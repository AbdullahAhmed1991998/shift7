import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/app/data/models/product_reviews_model.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_choose_color_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_choose_size_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_product_description_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_product_quantity_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_reviews_list_view_widget.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';

class CustomProductDetailsWidget extends StatefulWidget {
  final String description;
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final Key? sizesKey;
  final List<ProductReviewsModel> reviews;
  final int productId;
  final double rate;
  final bool? isFreeShipping;

  const CustomProductDetailsWidget({
    super.key,
    required this.description,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.quantity,
    required this.onQuantityChanged,
    this.sizesKey,
    required this.reviews,
    required this.productId,
    required this.rate,
    this.isFreeShipping,
  });

  @override
  State<CustomProductDetailsWidget> createState() =>
      _CustomProductDetailsWidgetState();
}

class _CustomProductDetailsWidgetState
    extends State<CustomProductDetailsWidget> {
  bool isLoggedIn = false;
  bool isLoading = true;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _secureStorage.read(key: userToken);
    if (mounted) {
      setState(() {
        isLoggedIn = token != null && token.isNotEmpty;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        if (widget.description.isNotEmpty)
          SliverToBoxAdapter(
            child: CustomProductDescriptionWidget(
              description: widget.description,
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        SliverToBoxAdapter(
          child: CustomDashedDivider(
            color: AppColors.greyColor,
            height: 15.h,
            thickness: 1,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'makeYourOrderNow'.tr(),
                  style: AppTextStyle.styleBlack16Bold,
                ),
                widget.isFreeShipping == false
                    ? SizedBox.shrink()
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 20.w,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            'freeDelivery'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.styleBlack14W500.copyWith(
                              color:
                                  widget.isFreeShipping == true
                                      ? AppColors.primaryColor
                                      : Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 15.h)),
        if (widget.colors.isNotEmpty)
          SliverToBoxAdapter(
            child: CustomChooseColorWidget(
              colors: widget.colors,
              initialSelected: widget.selectedColor,
              onColorSelected: widget.onColorSelected,
            ),
          ),
        if (widget.sizes.isNotEmpty)
          SliverToBoxAdapter(
            child: CustomChooseSizeWidget(
              key: widget.sizesKey,
              sizes: widget.sizes,
              initialSelected: widget.selectedSize,
              onSizeSelected: widget.onSizeSelected,
            ),
          ),
        SliverToBoxAdapter(
          child: CustomProductQuantityWidget(
            initialQuantity: widget.quantity,
            onQuantityChanged: widget.onQuantityChanged,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        SliverToBoxAdapter(
          child: CustomDashedDivider(
            color: AppColors.greyColor,
            height: 15.h,
            thickness: 1,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.rate == 0
                    ? Text('reviews'.tr(), style: AppTextStyle.styleBlack16Bold)
                    : Text(
                      "${'reviews'.tr()} ( ${widget.rate} ⭐ )",
                      style: AppTextStyle.styleBlack16Bold,
                    ),
                if (!isLoading && isLoggedIn)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutesKeys.productReview,
                        arguments: {
                          'isReviewPage': true,
                          'reviewsList': widget.reviews,
                          'productId': widget.productId,
                        },
                      );
                    },
                    child: Text(
                      'addReview'.tr(),
                      style: AppTextStyle.styleBlack14W500.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        SliverToBoxAdapter(
          child: CustomReviewsListViewWidget(
            reviews: widget.reviews,
            isReviewPage: false,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
      ],
    );
  }
}
