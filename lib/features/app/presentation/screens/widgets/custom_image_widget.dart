import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/assets/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;

  const CustomImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final imageHeight = screenHeight * 0.32;
    final imageWidth = screenWidth * 0.8;

    final widgetChild =
        imageUrl.isEmpty
            ? Image.asset(
              AppImages.appImage,
              fit: BoxFit.contain,
              height: imageHeight,
              width: imageWidth,
            )
            : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              height: imageHeight,
              width: imageWidth,
              placeholder:
                  (context, url) => _buildPlaceholder(imageHeight, imageWidth),
              errorWidget:
                  (context, url, error) => Image.asset(
                    AppImages.appImage,
                    fit: BoxFit.contain,
                    height: imageHeight,
                    width: imageWidth,
                  ),
            );

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: widgetChild,
      ),
    );
  }

  Widget _buildPlaceholder(double height, double width) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        color: Colors.grey.shade50,
        height: height,
        width: width,
      ),
    );
  }
}
