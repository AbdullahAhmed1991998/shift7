import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/widgets/custom_cached_network_image.dart';

class CustomImageContainer extends StatelessWidget {
  final String imageUrl;
  const CustomImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CustomCachedNetworkImage(
      imageUrl: imageUrl,
      height: 140.h,
      width: 120.w,
      radius: 20.r,
    );
  }
}
