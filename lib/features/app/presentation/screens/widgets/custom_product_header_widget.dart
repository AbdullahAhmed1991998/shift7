import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_image_carousel_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_title_product_widget.dart';

class CustomProductHeaderWidget extends StatelessWidget {
  final List<String> images;
  final String productName;
  final bool isFav;
  final int productId;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final String subtitle;

  const CustomProductHeaderWidget({
    super.key,
    required this.images,
    required this.productName,
    required this.isFav,
    required this.productId,
    required this.currentIndex,
    required this.onPageChanged,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageCarouselWidget(
          images: images,
          currentIndex: currentIndex,
          onPageChanged: onPageChanged,
          height: MediaQuery.sizeOf(context).height * .4,
        ),
        SizedBox(height: 5.h),
        CustomTitleProductWidget(
          title: productName,
          isFav: isFav,
          productId: productId,
        ),
      ],
    );
  }
}
